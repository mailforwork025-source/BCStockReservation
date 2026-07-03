codeunit 50106 "BCSR Availability Mgt."
{
    procedure GetOrCreateLockedBucket(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; var Bucket: Record "BCSR Availability Bucket")
var
    Item: Record Item;
    begin
    if not Item.Get(ItemNo) then
        Error(ItemNotFoundErr, ItemNo);

    Bucket.LockTable();
    Bucket.SetRange("Item No.", ItemNo);
    Bucket.SetRange("Variant Code", VariantCode);
    Bucket.SetRange("Location Code", LocationCode);
    if Bucket.FindFirst() then
        exit;

    Bucket.Init();
    Bucket."Bucket ID" := CreateGuid();
    Bucket."Item No." := ItemNo;
    Bucket."Variant Code" := VariantCode;
    Bucket."Location Code" := LocationCode;
    Bucket."Base Unit of Measure" := Item."Base Unit of Measure";
    Bucket.Insert(false);
    end;

    procedure RecalculateBucket(var Bucket: Record "BCSR Availability Bucket")
    var
        ReservationLine: Record "BCSR Reservation Line";
        BackorderLine: Record "BCSR Backorder Line";
    begin
        Bucket."Physical Qty." := CalculatePhysicalQty(Bucket."Item No.", Bucket."Variant Code", Bucket."Location Code");

        ReservationLine.SetRange("Bucket ID", Bucket."Bucket ID");
        ReservationLine.SetRange(Status, ReservationLine.Status::Reserved);
        Bucket."Reserved Qty." := SumReservedQty(ReservationLine);

        Clear(ReservationLine);
        ReservationLine.SetRange("Bucket ID", Bucket."Bucket ID");
        ReservationLine.SetFilter(Status, '%1|%2', ReservationLine.Status::PendingOrder, ReservationLine.Status::ManualReview);
        Bucket."Pending Order Qty." := SumReservedQty(ReservationLine);

        BackorderLine.SetRange("Item No.", Bucket."Item No.");
        BackorderLine.SetRange("Variant Code", Bucket."Variant Code");
        BackorderLine.SetRange("Location Code", Bucket."Location Code");
        BackorderLine.SetFilter(Status, '%1|%2|%3|%4', BackorderLine.Status::Open, BackorderLine.Status::LinkedToSalesLine, BackorderLine.Status::PartiallyAllocated, BackorderLine.Status::Allocated);
        Bucket."Backorder Qty." := SumBackorderQty(BackorderLine);

        Bucket."Native Reserved Qty." := CalculateNativeReservedQty(Bucket."Item No.", Bucket."Variant Code", Bucket."Location Code");

        Bucket."Last Recalculated" := CurrentDateTime;
        Bucket.Modify(false);
    end;

    procedure GetAvailableQtyBase(Bucket: Record "BCSR Availability Bucket"): Decimal
    begin
        exit(Bucket."Physical Qty." - Bucket."Reserved Qty." - Bucket."Pending Order Qty." - Bucket."Native Reserved Qty.");
    end;

    procedure CalculatePhysicalQty(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]): Decimal
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit(0);
        Item.SetRange("Variant Filter", VariantCode);
        Item.SetRange("Location Filter", LocationCode);
        Item.CalcFields(Inventory);
        exit(Item.Inventory);
    end;

    procedure CalculateNativeReservedQty(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]): Decimal
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit(0);
        Item.SetRange("Variant Filter", VariantCode);
        Item.SetRange("Location Filter", LocationCode);
        Item.CalcFields("Reserved Qty. on Sales Orders");
        exit(Item."Reserved Qty. on Sales Orders");
    end;

    procedure ToBaseQty(ItemNo: Code[20]; UomCode: Code[10]; Quantity: Decimal): Decimal
    var
        Item: Record Item;
        ItemUom: Record "Item Unit of Measure";
    begin
        if not Item.Get(ItemNo) then
            Error(ItemNotFoundErr, ItemNo);
        if UomCode = '' then
            UomCode := Item."Base Unit of Measure";
        if not ItemUom.Get(ItemNo, UomCode) then
            Error(UomNotFoundErr, UomCode, ItemNo);
        exit(Quantity * ItemUom."Qty. per Unit of Measure");
    end;

    local procedure SumReservedQty(var ReservationLine: Record "BCSR Reservation Line"): Decimal
    var
        Total: Decimal;
    begin
        if ReservationLine.FindSet() then
            repeat
                Total += ReservationLine."Reserved Qty. (Base)";
            until ReservationLine.Next() = 0;
        exit(Total);
    end;

    local procedure SumBackorderQty(var BackorderLine: Record "BCSR Backorder Line"): Decimal
    var
        Total: Decimal;
    begin
        if BackorderLine.FindSet() then
            repeat
                Total += BackorderLine."Quantity (Base)";
            until BackorderLine.Next() = 0;
        exit(Total);
    end;

    var
        ItemNotFoundErr: Label 'Item %1 was not found.', Comment = '%1 = Item No.';
        UomNotFoundErr: Label 'Unit of measure %1 was not found for item %2.', Comment = '%1 = UOM, %2 = Item No.';
}
