codeunit 50101 "BCSR Backorder Service"
{
    procedure CreateOrUpdateBackorder(IdempotencyKey: Text[150]; CorrelationId: Text[100]; WooOrderId: BigInteger; WooOrderNo: Text[50]; WooOrderLineId: BigInteger; BCSalesOrderSystemId: Guid; BCSalesOrderNo: Code[20]; BCSalesLineSystemId: Guid; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; UomCode: Code[10]; Quantity: Decimal; var ResponsePayload: Text): Boolean
    var
        Header: Record "BCSR Backorder Header";
        Line: Record "BCSR Backorder Line";
        Item: Record Item;
        IdempotencyMgt: Codeunit "BCSR Idempotency Mgt.";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
        AuditMgt: Codeunit "BCSR Audit Mgt.";
        OperationId: Guid;
        NullBackorderId: Guid;
        RequestPayload: Text;
        RequestHash: Text[250];
        QtyBase: Decimal;
    begin
        if IdempotencyKey = '' then
            exit(FailOperation(OperationId, IdempotencyMgt, 'IDEMPOTENCY_KEY_REQUIRED', 'Idempotency key is required.', ResponsePayload));

        RequestPayload := StrSubstNo('backorder|%1|%2|%3|%4|%5|%6', WooOrderId, WooOrderLineId, BCSalesLineSystemId, ItemNo, VariantCode, Quantity);
        RequestHash := IdempotencyMgt.CalculateRequestHash(RequestPayload);
        if IdempotencyMgt.TryReplay(IdempotencyKey, RequestHash, ResponsePayload) then
            exit(ResponseSucceeded(ResponsePayload));

        OperationId := IdempotencyMgt.StartOperation(IdempotencyKey, 'Backorder', RequestHash, RequestPayload, CorrelationId);
        if Quantity <= 0 then
            exit(FailOperation(OperationId, IdempotencyMgt, 'VALIDATION_FAILED', 'Backorder quantity must be greater than zero.', ResponsePayload));

        if not Item.Get(ItemNo) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'ITEM_NOT_FOUND', StrSubstNo('Item %1 was not found.', ItemNo), ResponsePayload));

        if not Item."BCSR Enable Backorder" then begin
            ResponsePayload := BuildBackorderDisabledResponse(ItemNo);
            IdempotencyMgt.CompleteOperation(OperationId, NullBackorderId, ResponsePayload, 200);
            exit(true);
        end;

        if not AvailabilityMgt.TryToBaseQty(ItemNo, UomCode, Quantity, QtyBase) then
            exit(FailOperation(OperationId, IdempotencyMgt, 'UOM_NOT_FOUND', CopyStr(GetLastErrorText(), 1, 250), ResponsePayload));

        EnsureHeader(WooOrderId, WooOrderNo, BCSalesOrderSystemId, BCSalesOrderNo, CorrelationId, Header);
        if not GetLine(WooOrderId, WooOrderLineId, Line) then begin
            Line.Init();
            Line."Backorder ID" := Header."Backorder ID";
            Line."Line No." := NextLineNo(Header."Backorder ID");
            Line."Woo Order ID" := WooOrderId;
            Line."Woo Order Line ID" := WooOrderLineId;
            Line.Insert(true);
        end;

        Line."BC Sales Line System ID" := BCSalesLineSystemId;
        Line."Item No." := ItemNo;
        Line."Variant Code" := VariantCode;
        Line."Location Code" := LocationCode;
        Line."Unit of Measure Code" := UomCode;
        Line.Quantity := Quantity;
        Line."Quantity (Base)" := QtyBase;
        Line.Status := Line.Status::LinkedToSalesLine;
        Line."Correlation ID" := CorrelationId;
        Line.Modify(true);

        Header.Status := Header.Status::LinkedToSalesLine;
        Header.Modify(true);

        ResponsePayload :=
            '{' +
            JsonPair('success', 'true', false) + ',' +
            JsonPair('backorderEnabled', 'true', false) + ',' +
            JsonPair('backorderId', Format(Header."Backorder ID"), true) + ',' +
            JsonPair('backorderLineId', Format(Line."Backorder Line ID"), true) + ',' +
            JsonPair('status', Format(Line.Status), true) + ',' +
            JsonPair('correlationId', CorrelationId, true) +
            '}';
        IdempotencyMgt.CompleteOperation(OperationId, Header."Backorder ID", ResponsePayload, 200);
        AuditMgt.LogBackorder(Header."Backorder ID", 'CreateOrUpdateBackorder', '', Format(Line.Status), 'Backorder linked to WooCommerce and BC sales line.', OperationId, CorrelationId);
        exit(true);
    end;

    procedure GetOpenBackorderQty(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]): Decimal
    var
        BackorderLine: Record "BCSR Backorder Line";
        Total: Decimal;
    begin
        BackorderLine.SetRange("Item No.", ItemNo);
        BackorderLine.SetRange("Variant Code", VariantCode);
        BackorderLine.SetRange("Location Code", LocationCode);
        BackorderLine.SetFilter(Status, '%1|%2|%3|%4', BackorderLine.Status::Open, BackorderLine.Status::LinkedToSalesLine, BackorderLine.Status::PartiallyAllocated, BackorderLine.Status::Allocated);
        if BackorderLine.FindSet() then
            repeat
                Total += BackorderLine."Quantity (Base)";
            until BackorderLine.Next() = 0;
        exit(Total);
    end;

    local procedure EnsureHeader(WooOrderId: BigInteger; WooOrderNo: Text[50]; BCSalesOrderSystemId: Guid; BCSalesOrderNo: Code[20]; CorrelationId: Text[100]; var Header: Record "BCSR Backorder Header")
    begin
        Header.SetRange("Woo Order ID", WooOrderId);
        if Header.FindFirst() then begin
            Header."Woo Order No." := WooOrderNo;
            Header."BC Sales Order System ID" := BCSalesOrderSystemId;
            Header."BC Sales Order No." := BCSalesOrderNo;
            Header."Correlation ID" := CorrelationId;
            Header.Modify(true);
            exit;
        end;

        Header.Init();
        Header."Woo Order ID" := WooOrderId;
        Header."Woo Order No." := WooOrderNo;
        Header."BC Sales Order System ID" := BCSalesOrderSystemId;
        Header."BC Sales Order No." := BCSalesOrderNo;
        Header.Status := Header.Status::Open;
        Header."Correlation ID" := CorrelationId;
        Header.Insert(true);
    end;

    local procedure GetLine(WooOrderId: BigInteger; WooOrderLineId: BigInteger; var Line: Record "BCSR Backorder Line"): Boolean
    begin
        Line.SetRange("Woo Order ID", WooOrderId);
        Line.SetRange("Woo Order Line ID", WooOrderLineId);
        exit(Line.FindFirst());
    end;

    local procedure NextLineNo(BackorderId: Guid): Integer
    var
        Line: Record "BCSR Backorder Line";
    begin
        Line.SetRange("Backorder ID", BackorderId);
        if Line.FindLast() then
            exit(Line."Line No." + 10000);
        exit(10000);
    end;

    local procedure FailOperation(OperationId: Guid; var IdempotencyMgt: Codeunit "BCSR Idempotency Mgt."; ErrorCode: Text[50]; Message: Text[250]; var ResponsePayload: Text): Boolean
    begin
        ResponsePayload := '{"success":false,"errorCode":"' + ErrorCode + '","message":"' + Message + '"}';
        IdempotencyMgt.FailOperation(OperationId, ErrorCode, Message, ResponsePayload, 400);
        exit(false);
    end;

    local procedure ResponseSucceeded(ResponsePayload: Text): Boolean
    begin
        exit(StrPos(ResponsePayload, '"success":true') > 0);
    end;

    local procedure BuildBackorderDisabledResponse(ItemNo: Code[20]): Text
    begin
        exit(
            '{' +
            JsonPair('success', 'true', false) + ',' +
            JsonPair('backorderEnabled', 'false', false) + ',' +
            JsonPair('itemNo', ItemNo, true) + ',' +
            JsonPair('message', 'Backorder is not enabled for this item.', true) +
            '}');
    end;

    local procedure JsonPair(Name: Text; Value: Text; QuoteValue: Boolean): Text
    begin
        if QuoteValue then
            exit('"' + Name + '":"' + Value.Replace('\', '\\').Replace('"', '\"') + '"');
        exit('"' + Name + '":' + Value);
    end;
}
