codeunit 50100 "BCSR Reservation Service"
{
    procedure Reserve(IdempotencyKey: Text[150]; CorrelationId: Text[100]; WooSessionId: Text[100]; WooCustomerId: Text[100]; WooCartHash: Text[100]; WooCartItemKey: Text[100]; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; UomCode: Code[10]; Quantity: Decimal; var ResponsePayload: Text): Boolean
    var
        Setup: Record "BCSR Setup";
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        Item: Record Item;
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        QtyBase: Decimal;
        ReservedBase: Decimal;
        BackorderBase: Decimal;
        AvailableBase: Decimal;
        QtyDifference: Decimal;
        QtyDifferenceBase: Decimal;
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := BuildReservePayload(WooSessionId, WooCartItemKey, ItemNo, VariantCode, LocationCode, UomCode, Quantity);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'Reserve', RequestHash, RequestPayload, CorrelationId);
        Setup.GetSetup();

        if not Setup."Enable New Reservations" then
            exit(FailOperation(OperationId, IdempotencyMgt, 'RESERVATIONS_DISABLED', 'New reservations are disabled.', ResponsePayload));

        if Quantity <= 0 then
            exit(FailOperation(OperationId, IdempotencyMgt, 'VALIDATION_FAILED', 'Quantity must be greater than zero.', ResponsePayload));

        if LocationCode = '' then
            LocationCode := Setup."Website Location Code";
        if LocationCode = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'LOCATION_REQUIRED', 'Website location is not configured.', ResponsePayload));

        if not Item.Get(ItemNo) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'ITEM_NOT_FOUND', StrSubstNo('Item %1 was not found.', ItemNo), ResponsePayload));

        if not AvailabilityMgt.TryToBaseQty(ItemNo, UomCode, Quantity, QtyBase) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'UOM_NOT_FOUND', CopyStr(GetLastErrorText(), 1, 250), ResponsePayload));

        AvailabilityMgt.GetOrCreateLockedBucket(ItemNo, VariantCode, LocationCode, Bucket);
        AvailabilityMgt.RecalculateBucket(Bucket);

        EnsureSessionHeader(WooSessionId, WooCustomerId, WooCartHash, CorrelationId, OperationId, Header);
        if GetLine(Header."Reservation ID", WooCartItemKey, Line) then begin
            if Quantity < Line.Quantity then begin
                // Quantity reduction: partially release only the difference
                QtyDifference := Line.Quantity - Quantity;
                QtyDifferenceBase := Line."Quantity (Base)" - QtyBase;
                
                // If there was a backorder, reduce it first
                if Line."Backorder Qty. (Base)" >= QtyDifferenceBase then begin
                    Line."Backorder Qty. (Base)" -= QtyDifferenceBase;
                end else begin
                    QtyDifferenceBase -= Line."Backorder Qty. (Base)";
                    Line."Backorder Qty. (Base)" := 0;
                    Line."Reserved Qty. (Base)" -= QtyDifferenceBase;
                end;
                
                Line.Quantity := Quantity;
                Line."Quantity (Base)" := QtyBase;
                Line."Correlation ID" := CorrelationId;
                Line.Modify(true);
                
                AvailabilityMgt.RecalculateBucket(Bucket);
                
                Header.Status := Header.Status::Reserved;
                Header."Expires At" := CurrentDateTime + Setup."Reservation Duration (Min.)" * 60000;
                Header."Last Operation ID" := OperationId;
                Header.Modify(true);
                
                ResponsePayload := BuildReserveResponse(Header."Reservation ID", Line."Reservation Line ID", Header.Status, Line."Reserved Qty. (Base)", Line."Backorder Qty. (Base)", Header."Expires At", CorrelationId);
                IdempotencyMgt.CompleteOperation(OperationId, Header."Reservation ID", ResponsePayload, 200);
                AuditMgt.LogReservation(Header."Reservation ID", 'PartialRelease', '', Format(Header.Status), StrSubstNo('Quantity reduced from %1 to %2 for item %3.', Quantity + QtyDifference, Quantity, ItemNo), OperationId, CorrelationId);
                exit(true);
            end;
            
            ReleaseLineForReprice(Line, AuditMgt, OperationId, CorrelationId);
            AvailabilityMgt.RecalculateBucket(Bucket);
        end else begin
            Line.Init();
            Line."Reservation ID" := Header."Reservation ID";
            Line."Line No." := NextLineNo(Header."Reservation ID");
            Line."Woo Cart Item Key" := WooCartItemKey;
        end;

        AvailableBase := AvailabilityMgt.GetAvailableQtyBase(Bucket);
        if AvailableBase >= QtyBase then begin
            ReservedBase := QtyBase;
            BackorderBase := 0;
        end else begin
            ReservedBase := MaxDecimal(AvailableBase, 0);
            BackorderBase := QtyBase - ReservedBase;
            if (BackorderBase > 0) and not Setup."Enable Backorders" then
                exit(FailOperation(OperationId, IdempotencyMgt, 'INSUFFICIENT_STOCK', 'Insufficient stock for reservation.', ResponsePayload));
        end;

        Line."Item No." := ItemNo;
        Line."Variant Code" := VariantCode;
        Line."Location Code" := LocationCode;
        Line."Unit of Measure Code" := UomCode;
        Line.Quantity := Quantity;
        Line."Quantity (Base)" := QtyBase;
        Line."Reserved Qty. (Base)" := ReservedBase;
        Line."Backorder Qty. (Base)" := BackorderBase;
        Line."Bucket ID" := Bucket."Bucket ID";
        Line.Status := Line.Status::Reserved;
        Line."Correlation ID" := CorrelationId;
        if IsNullGuid(Line."Reservation Line ID") then
            Line.Insert(true)
        else
            Line.Modify(true);

        Header.Status := Header.Status::Reserved;
        Header."Expires At" := CurrentDateTime + Setup."Reservation Duration (Min.)" * 60000;
        Header."Last Operation ID" := OperationId;
        Header.Modify(true);

        AvailabilityMgt.RecalculateBucket(Bucket);

        ResponsePayload := BuildReserveResponse(Header."Reservation ID", Line."Reservation Line ID", Header.Status, ReservedBase, BackorderBase, Header."Expires At", CorrelationId);
        IdempotencyMgt.CompleteOperation(OperationId, Header."Reservation ID", ResponsePayload, 200);
        AuditMgt.LogReservation(Header."Reservation ID", 'Reserve', '', Format(Header.Status), 'Reservation updated from WooCommerce cart.', OperationId, CorrelationId);
        exit(true);
    end;

    procedure Release(IdempotencyKey: Text[150]; CorrelationId: Text[100]; ReservationId: Guid; Reason: Text[100]; var ResponsePayload: Text): Boolean
    var
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        FromStatus: Text[30];
        NativeUnreserveFailed: Boolean;
        ManualReviewReason: Text[250];
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := StrSubstNo('release|%1|%2', ReservationId, Reason);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'Release', RequestHash, RequestPayload, CorrelationId);
        if not Header.Get(ReservationId) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'RESERVATION_NOT_FOUND', 'Reservation was not found.', ResponsePayload));

        FromStatus := Format(Header.Status);
        Line.SetRange("Reservation ID", ReservationId);
        Line.SetFilter(Status, '%1|%2|%3|%4', Line.Status::Reserved, Line.Status::PendingOrder, Line.Status::ManualReview, Line.Status::Confirmed);
        if Line.FindSet(true) then
            repeat
                if Line.Status = Line.Status::Confirmed then
                    if not TryUnreserveSalesLine(Line) then begin
                        NativeUnreserveFailed := true;
                        ManualReviewReason := CopyStr(GetLastErrorText(), 1, 250);
                        AuditMgt.LogReservation(ReservationId, 'NativeUnreserveFailed', Format(Line.Status), Format(Line.Status), ManualReviewReason, OperationId, CorrelationId);
                    end;

                if Bucket.Get(Line."Bucket ID") then begin
                    Bucket.LockTable();
                    Line.Status := Line.Status::Released;
                    Line.Modify(true);
                    AvailabilityMgt.RecalculateBucket(Bucket);
                end;
            until Line.Next() = 0;

        if NativeUnreserveFailed then begin
            Header.Status := Header.Status::ManualReview;
            Header."Manual Review Reason" := ManualReviewReason;
        end else
            Header.Status := Header.Status::Released;
        Header."Last Operation ID" := OperationId;
        Header.Modify(true);

        ResponsePayload := BuildStatusResponse(ReservationId, Header.Status, CorrelationId);
        IdempotencyMgt.CompleteOperation(OperationId, ReservationId, ResponsePayload, 200);
        AuditMgt.LogReservation(ReservationId, 'Release', FromStatus, Format(Header.Status), CopyStr(Reason, 1, 250), OperationId, CorrelationId);
        exit(true);
    end;

    procedure ReleaseLine(IdempotencyKey: Text[150]; CorrelationId: Text[100]; ReservationId: Guid; WooCartItemKey: Text[100]; var ResponsePayload: Text): Boolean
    var
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        FromStatus: Text[30];
        NativeUnreserveFailed: Boolean;
        ManualReviewReason: Text[250];
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := StrSubstNo('releaseLine|%1|%2', ReservationId, WooCartItemKey);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'ReleaseLine', RequestHash, RequestPayload, CorrelationId);
        if not Header.Get(ReservationId) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'RESERVATION_NOT_FOUND', 'Reservation was not found.', ResponsePayload));

        Line.SetRange("Reservation ID", ReservationId);
        Line.SetRange("Woo Cart Item Key", WooCartItemKey);
        Line.SetFilter(Status, '%1|%2|%3|%4', Line.Status::Reserved, Line.Status::PendingOrder, Line.Status::ManualReview, Line.Status::Confirmed);
        if not Line.FindFirst() then begin
            ResponsePayload := BuildStatusResponse(ReservationId, Header.Status, CorrelationId);
            IdempotencyMgt.CompleteOperation(OperationId, ReservationId, ResponsePayload, 200);
            exit(true);
        end;

        FromStatus := Format(Line.Status);
        if Line.Status = Line.Status::Confirmed then
            if not TryUnreserveSalesLine(Line) then begin
                NativeUnreserveFailed := true;
                ManualReviewReason := CopyStr(GetLastErrorText(), 1, 250);
                AuditMgt.LogReservation(ReservationId, 'NativeUnreserveFailed', FromStatus, FromStatus, ManualReviewReason, OperationId, CorrelationId);
            end;

        if Bucket.Get(Line."Bucket ID") then begin
            Bucket.LockTable();
            Line.Status := Line.Status::Released;
            Line.Modify(true);
            AvailabilityMgt.RecalculateBucket(Bucket);
        end;

        Line.Reset();
        Line.SetRange("Reservation ID", ReservationId);
        Line.SetFilter(Status, '%1|%2|%3|%4', Line.Status::Reserved, Line.Status::PendingOrder, Line.Status::ManualReview, Line.Status::Confirmed);
        if not Line.FindFirst() then begin
            if NativeUnreserveFailed then begin
                Header.Status := Header.Status::ManualReview;
                Header."Manual Review Reason" := ManualReviewReason;
            end else
                Header.Status := Header.Status::Released;
            Header."Last Operation ID" := OperationId;
            Header.Modify(true);
        end;

        ResponsePayload := BuildStatusResponse(ReservationId, Header.Status, CorrelationId);
        IdempotencyMgt.CompleteOperation(OperationId, ReservationId, ResponsePayload, 200);
        AuditMgt.LogReservation(ReservationId, 'ReleaseLine', FromStatus, Format(Line.Status), StrSubstNo('Released line: %1', WooCartItemKey), OperationId, CorrelationId);
        exit(true);
    end;

    procedure ConvertToPendingOrder(IdempotencyKey: Text[150]; CorrelationId: Text[100]; ReservationId: Guid; WooOrderId: BigInteger; WooOrderNo: Text[50]; var ResponsePayload: Text): Boolean
    var
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        FromStatus: Text[30];
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := StrSubstNo('convert|%1|%2|%3', ReservationId, WooOrderId, WooOrderNo);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'Convert', RequestHash, RequestPayload, CorrelationId);
        if not Header.Get(ReservationId) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'RESERVATION_NOT_FOUND', 'Reservation was not found.', ResponsePayload));
        if not (Header.Status in [Header.Status::Reserved, Header.Status::ManualReview]) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'STATE_TRANSITION_INVALID', 'Reservation cannot be converted from its current state.', ResponsePayload));

        FromStatus := Format(Header.Status);
        Header.Status := Header.Status::PendingOrder;
        Header."Woo Order ID" := WooOrderId;
        Header."Woo Order No." := WooOrderNo;
        Header."Expires At" := 0DT;
        Header."Last Operation ID" := OperationId;
        Header.Modify(true);

        Line.SetRange("Reservation ID", ReservationId);
        Line.SetFilter(Status, '%1|%2', Line.Status::Reserved, Line.Status::ManualReview);
        if Line.FindSet(true) then
            repeat
                if Bucket.Get(Line."Bucket ID") then begin
                    Bucket.LockTable();
                    Line.Status := Line.Status::PendingOrder;
                    Line.Modify(true);
                    AvailabilityMgt.RecalculateBucket(Bucket);
                end;
            until Line.Next() = 0;

        ResponsePayload := BuildStatusResponse(ReservationId, Header.Status, CorrelationId);
        IdempotencyMgt.CompleteOperation(OperationId, ReservationId, ResponsePayload, 200);
        AuditMgt.LogReservation(ReservationId, 'Convert', FromStatus, Format(Header.Status), 'WooCommerce order created; waiting for BC sales order sync.', OperationId, CorrelationId);
        exit(true);
    end;

    procedure ConfirmSync(IdempotencyKey: Text[150]; CorrelationId: Text[100]; ReservationId: Guid; WooOrderId: BigInteger; BCSalesOrderSystemId: Guid; BCSalesOrderNo: Code[20]; var ResponsePayload: Text): Boolean
    var
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        FromStatus: Text[30];
        FullyReserved: Boolean;
        NativeReservationFailed: Boolean;
        ManualReviewReason: Text[250];
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := StrSubstNo('confirm|%1|%2|%3|%4', ReservationId, WooOrderId, BCSalesOrderSystemId, BCSalesOrderNo);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'ConfirmSync', RequestHash, RequestPayload, CorrelationId);
        if not Header.Get(ReservationId) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'RESERVATION_NOT_FOUND', 'Reservation was not found.', ResponsePayload));
        if not (Header.Status in [Header.Status::PendingOrder, Header.Status::ManualReview]) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'STATE_TRANSITION_INVALID', 'Reservation cannot be confirmed from its current state.', ResponsePayload));

        FromStatus := Format(Header.Status);
        Header.Status := Header.Status::Confirmed;
        Header."Woo Order ID" := WooOrderId;
        Header."BC Sales Order System ID" := BCSalesOrderSystemId;
        Header."BC Sales Order No." := BCSalesOrderNo;
        Header."Last Operation ID" := OperationId;
        Header.Modify(true);

        Line.SetRange("Reservation ID", ReservationId);
        Line.SetFilter(Status, '%1|%2|%3', Line.Status::Reserved, Line.Status::PendingOrder, Line.Status::ManualReview);
        if Line.FindSet(true) then
            repeat
                if Bucket.Get(Line."Bucket ID") then begin
                    Bucket.LockTable();
                    Line.Status := Line.Status::Confirmed;
                    Line.Modify(true);
                    AvailabilityMgt.RecalculateBucket(Bucket);
                end;

                Clear(FullyReserved);
                if TryReserveSalesLine(BCSalesOrderNo, Line, FullyReserved) then begin
                    Line.Modify(true);
                    if not FullyReserved then begin
                        NativeReservationFailed := true;
                        ManualReviewReason := CopyStr(StrSubstNo('Native BC reservation for item %1 only partially succeeded (insufficient available inventory).', Line."Item No."), 1, 250);
                        AuditMgt.LogReservation(ReservationId, 'NativeReservePartial', Format(Line.Status), Format(Line.Status), ManualReviewReason, OperationId, CorrelationId);
                    end;
                end else begin
                    NativeReservationFailed := true;
                    ManualReviewReason := CopyStr(GetLastErrorText(), 1, 250);
                    AuditMgt.LogReservation(ReservationId, 'NativeReserveFailed', Format(Line.Status), Format(Line.Status), ManualReviewReason, OperationId, CorrelationId);
                end;
            until Line.Next() = 0;

        if NativeReservationFailed then begin
            Header.Status := Header.Status::ManualReview;
            Header."Manual Review Reason" := ManualReviewReason;
            Header.Modify(true);
        end;

        ResponsePayload := BuildStatusResponse(ReservationId, Header.Status, CorrelationId);
        IdempotencyMgt.CompleteOperation(OperationId, ReservationId, ResponsePayload, 200);
        AuditMgt.LogReservation(ReservationId, 'ConfirmSync', FromStatus, Format(Header.Status), 'Existing WooCommerce sync linked to BC sales order.', OperationId, CorrelationId);
        exit(true);
    end;

    procedure MarkManualReview(IdempotencyKey: Text[150]; CorrelationId: Text[100]; ReservationId: Guid; Reason: Text[250]; var ResponsePayload: Text): Boolean
    var
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        FromStatus: Text[30];
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := StrSubstNo('manualReview|%1|%2', ReservationId, Reason);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'ManualReview', RequestHash, RequestPayload, CorrelationId);
        if not Header.Get(ReservationId) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'RESERVATION_NOT_FOUND', 'Reservation was not found.', ResponsePayload));

        FromStatus := Format(Header.Status);
        Header.Status := Header.Status::ManualReview;
        Header."Manual Review Reason" := Reason;
        Header."Last Operation ID" := OperationId;
        Header.Modify(true);

        Line.SetRange("Reservation ID", ReservationId);
        Line.SetFilter(Status, '%1|%2', Line.Status::Reserved, Line.Status::PendingOrder);
        if Line.FindSet(true) then
            repeat
                if Bucket.Get(Line."Bucket ID") then begin
                    Bucket.LockTable();
                    Line.Status := Line.Status::ManualReview;
                    Line.Modify(true);
                    AvailabilityMgt.RecalculateBucket(Bucket);
                end;
            until Line.Next() = 0;

        ResponsePayload := BuildStatusResponse(ReservationId, Header.Status, CorrelationId);
        IdempotencyMgt.CompleteOperation(OperationId, ReservationId, ResponsePayload, 200);
        AuditMgt.LogReservation(ReservationId, 'ManualReview', FromStatus, Format(Header.Status), Reason, OperationId, CorrelationId);
        exit(true);
    end;

    procedure ReleaseExpiredReservations(): Integer
    var
        Setup: Record "BCSR Setup";
        Header: Record "BCSR Reservation Header";
        Line: Record "BCSR Reservation Line";
        Bucket: Record "BCSR Availability Bucket";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        ReleasedCount: Integer;
        PendingCutoff: DateTime;
    begin
        Setup.GetSetup();
        if not Setup."Auto Release Enabled" then
            exit(0);

        Header.SetRange(Status, Header.Status::Reserved);
        Header.SetFilter("Expires At", '<>%1&<=%2', 0DT, CurrentDateTime);
        if Header.FindSet(true) then
            repeat
                Line.SetRange("Reservation ID", Header."Reservation ID");
                Line.SetRange(Status, Line.Status::Reserved);
                if Line.FindSet(true) then
                    repeat
                        if Bucket.Get(Line."Bucket ID") then begin
                            Bucket.LockTable();
                            Line.Status := Line.Status::Expired;
                            Line.Modify(true);
                            AvailabilityMgt.RecalculateBucket(Bucket);
                        end;
                    until Line.Next() = 0;
                Header.Status := Header.Status::Expired;
                Header.Modify(true);
                AuditMgt.LogReservation(Header."Reservation ID", 'Expire', '', Format(Header.Status), 'Reservation expired by job queue.', Header."Last Operation ID", Header."Correlation ID");
                ReleasedCount += 1;
                if ReleasedCount >= Setup."Cleanup Batch Size" then
                    exit(ReleasedCount);
            until Header.Next() = 0;

        PendingCutoff := CurrentDateTime - Setup."Pending Order Timeout (Min.)" * 60000;
        Header.Reset();
        Header.SetRange(Status, Header.Status::PendingOrder);
        Header.SetFilter("Modified DateTime", '<=%1', PendingCutoff);
        if Header.FindSet(true) then
            repeat
                Line.SetRange("Reservation ID", Header."Reservation ID");
                Line.SetRange(Status, Line.Status::PendingOrder);
                if Line.FindSet(true) then
                    repeat
                        if Bucket.Get(Line."Bucket ID") then begin
                            Bucket.LockTable();
                            Line.Status := Line.Status::ManualReview;
                            Line.Modify(true);
                            AvailabilityMgt.RecalculateBucket(Bucket);
                        end;
                    until Line.Next() = 0;
                Header.Status := Header.Status::ManualReview;
                Header."Manual Review Reason" := 'Pending order exceeded sync confirmation timeout.';
                Header.Modify(true);
                AuditMgt.LogReservation(Header."Reservation ID", 'PendingTimeout', '', Format(Header.Status), Header."Manual Review Reason", Header."Last Operation ID", Header."Correlation ID");
                ReleasedCount += 1;
                if ReleasedCount >= Setup."Cleanup Batch Size" then
                    exit(ReleasedCount);
            until Header.Next() = 0;
        exit(ReleasedCount);
    end;

    procedure GetAvailability(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; UomCode: Code[10]; var ResponsePayload: Text): Boolean
    var
        Setup: Record "BCSR Setup";
        Bucket: Record "BCSR Availability Bucket";
        Item: Record Item;
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AvailableBase: Decimal;
    begin
        if not Item.Get(ItemNo) then begin
            ResponsePayload := BuildErrorResponse('ITEM_NOT_FOUND', StrSubstNo('Item %1 was not found.', ItemNo));
            exit(false);
        end;

        Setup.GetSetup();
        if LocationCode = '' then
            LocationCode := Setup."Website Location Code";
        AvailabilityMgt.GetOrCreateLockedBucket(ItemNo, VariantCode, LocationCode, Bucket);
        AvailabilityMgt.RecalculateBucket(Bucket);
        AvailableBase := AvailabilityMgt.GetAvailableQtyBase(Bucket);
        ResponsePayload :=
            '{' +
            JsonPair('success', 'true', false) + ',' +
            JsonPair('itemNo', ItemNo, true) + ',' +
            JsonPair('variantCode', VariantCode, true) + ',' +
            JsonPair('locationCode', LocationCode, true) + ',' +
            JsonPair('uomCode', UomCode, true) + ',' +
            JsonPair('physicalQtyBase', FormatDecimal(Bucket."Physical Qty."), false) + ',' +
            JsonPair('reservedQtyBase', FormatDecimal(Bucket."Reserved Qty."), false) + ',' +
            JsonPair('pendingOrderQtyBase', FormatDecimal(Bucket."Pending Order Qty."), false) + ',' +
            JsonPair('backorderQtyBase', FormatDecimal(Bucket."Backorder Qty."), false) + ',' +
            JsonPair('availableQtyBase', FormatDecimal(AvailableBase), false) +
            '}';
        exit(true);
    end;

    local procedure EnsureSessionHeader(WooSessionId: Text[100]; WooCustomerId: Text[100]; WooCartHash: Text[100]; CorrelationId: Text[100]; OperationId: Guid; var Header: Record "BCSR Reservation Header")
    begin
        Header.SetRange("Woo Session ID", WooSessionId);
        Header.SetFilter(Status, '%1|%2', Header.Status::Reserved, Header.Status::PendingOrder);
        if Header.FindFirst() then
            exit;

        Header.Init();
        Header."Woo Session ID" := WooSessionId;
        Header."Woo Customer ID" := WooCustomerId;
        Header."Woo Cart Hash" := WooCartHash;
        Header.Status := Header.Status::Reserved;
        Header."Correlation ID" := CorrelationId;
        Header."Last Operation ID" := OperationId;
        Header.Insert(true);
    end;

    local procedure GetLine(ReservationId: Guid; WooCartItemKey: Text[100]; var Line: Record "BCSR Reservation Line"): Boolean
    begin
        Line.SetRange("Reservation ID", ReservationId);
        Line.SetRange("Woo Cart Item Key", WooCartItemKey);
        exit(Line.FindFirst());
    end;

    local procedure ReleaseLineForReprice(var Line: Record "BCSR Reservation Line"; AuditMgt: Codeunit "BCSR Audit Mgt."; OperationId: Guid; CorrelationId: Text[100])
    var
        OldStatus: Text[30];
    begin
        if not (Line.Status in [Line.Status::Reserved, Line.Status::PendingOrder]) then
            exit;
        OldStatus := Format(Line.Status);
        Line.Status := Line.Status::Released;
        Line.Modify(true);
        AuditMgt.LogReservation(Line."Reservation ID", 'ReleaseLineForReprice', OldStatus, Format(Line.Status), 'Previous cart line reservation released before re-reserve.', OperationId, CorrelationId);
    end;

    [TryFunction]
    local procedure TryReserveSalesLine(BCSalesOrderNo: Code[20]; var ReservationLine: Record "BCSR Reservation Line"; var FullyReserved: Boolean)
    var
        SalesLine: Record "Sales Line";
        ReservMgt: Codeunit "Reservation Management";
        NoUniqueSalesLineErr: Label 'Could not uniquely match a Sales Line for item %1 on sales order %2 (%3 candidate line(s) found).', Comment = '%1 = Item No., %2 = Sales Order No., %3 = Number of matching lines found';
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", BCSalesOrderNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", ReservationLine."Item No.");
        SalesLine.SetRange("Variant Code", ReservationLine."Variant Code");
        SalesLine.SetRange("Location Code", ReservationLine."Location Code");
        if SalesLine.Count() <> 1 then
            Error(NoUniqueSalesLineErr, ReservationLine."Item No.", BCSalesOrderNo, SalesLine.Count());
        SalesLine.FindFirst();
        SalesLine.TestField("Shipment Date");

        ReservMgt.SetReservSource(SalesLine);
        ReservMgt.AutoReserve(FullyReserved, '', SalesLine."Shipment Date", ReservationLine.Quantity, ReservationLine."Reserved Qty. (Base)");
        ReservationLine."BC Sales Line System ID" := SalesLine.SystemId;
    end;

    [TryFunction]
    local procedure TryUnreserveSalesLine(var ReservationLine: Record "BCSR Reservation Line")
    var
        SalesLine: Record "Sales Line";
        ReservMgt: Codeunit "Reservation Management";
    begin
        if IsNullGuid(ReservationLine."BC Sales Line System ID") then
            exit;
        if not SalesLine.GetBySystemId(ReservationLine."BC Sales Line System ID") then
            exit;

        ReservMgt.SetReservSource(SalesLine);
        ReservMgt.DeleteReservEntries(true, 0);
    end;

    local procedure NextLineNo(ReservationId: Guid): Integer
    var
        Line: Record "BCSR Reservation Line";
    begin
        Line.SetRange("Reservation ID", ReservationId);
        if Line.FindLast() then
            exit(Line."Line No." + 10000);
        exit(10000);
    end;

    local procedure FailOperation(OperationId: Guid; var IdempotencyMgt: Codeunit "BCSR Idempotency Mgt."; ErrorCode: Text[50]; Message: Text[250]; var ResponsePayload: Text): Boolean
    begin
        ResponsePayload := BuildErrorResponse(ErrorCode, Message);
        IdempotencyMgt.FailOperation(OperationId, ErrorCode, Message, ResponsePayload, 400);
        exit(false);
    end;

    local procedure ResponseSucceeded(ResponsePayload: Text): Boolean
    begin
        exit(StrPos(ResponsePayload, '"success":true') > 0);
    end;

    local procedure BuildReservePayload(WooSessionId: Text; WooCartItemKey: Text; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; UomCode: Code[10]; Quantity: Decimal): Text
    begin
        exit(StrSubstNo('reserve|%1|%2|%3|%4|%5|%6|%7', WooSessionId, WooCartItemKey, ItemNo, VariantCode, LocationCode, UomCode, Quantity));
    end;

    local procedure BuildReserveResponse(ReservationId: Guid; ReservationLineId: Guid; Status: Enum "BCSR Reservation Status"; ReservedBase: Decimal; BackorderBase: Decimal; ExpiresAt: DateTime; CorrelationId: Text[100]): Text
    begin
        exit(
            '{' +
            JsonPair('success', 'true', false) + ',' +
            JsonPair('reservationId', Format(ReservationId), true) + ',' +
            JsonPair('reservationLineId', Format(ReservationLineId), true) + ',' +
            JsonPair('status', Format(Status), true) + ',' +
            JsonPair('reservedQtyBase', FormatDecimal(ReservedBase), false) + ',' +
            JsonPair('backorderQtyBase', FormatDecimal(BackorderBase), false) + ',' +
            JsonPair('expiresAt', Format(ExpiresAt, 0, 9), true) + ',' +
            JsonPair('correlationId', CorrelationId, true) +
            '}');
    end;

    local procedure BuildStatusResponse(ReservationId: Guid; Status: Enum "BCSR Reservation Status"; CorrelationId: Text[100]): Text
    begin
        exit(
            '{' +
            JsonPair('success', 'true', false) + ',' +
            JsonPair('reservationId', Format(ReservationId), true) + ',' +
            JsonPair('status', Format(Status), true) + ',' +
            JsonPair('correlationId', CorrelationId, true) +
            '}');
    end;

    local procedure BuildErrorResponse(ErrorCode: Text[50]; Message: Text[250]): Text
    begin
        exit(
            '{' +
            JsonPair('success', 'false', false) + ',' +
            JsonPair('errorCode', ErrorCode, true) + ',' +
            JsonPair('message', Message, true) +
            '}');
    end;

    local procedure JsonPair(Name: Text; Value: Text; QuoteValue: Boolean): Text
    begin
        if QuoteValue then
            exit('"' + Name + '":"' + EscapeJson(Value) + '"');
        exit('"' + Name + '":' + Value);
    end;

    local procedure EscapeJson(Value: Text): Text
    begin
        exit(Value.Replace('\', '\\').Replace('"', '\"'));
    end;

    local procedure FormatDecimal(Value: Decimal): Text
    begin
        exit(Format(Value, 0, 9));
    end;

    local procedure MaxDecimal(Value: Decimal; Minimum: Decimal): Decimal
    begin
        if Value < Minimum then
            exit(Minimum);
        exit(Value);
    end;
}
