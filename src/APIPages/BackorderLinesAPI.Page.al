page 50114 "BCSR Backorder Lines API"
{
    PageType = API;
    Caption = 'BCSR Backorder Lines API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'backorderLine';
    EntitySetName = 'backorderLines';
    SourceTable = "BCSR Backorder Line";
    ODataKeyFields = SystemId;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(systemId; Rec.SystemId) { Caption = 'System Id'; }
                field(backorderLineId; Rec."Backorder Line ID") { Caption = 'Backorder Line Id'; }
                field(backorderId; Rec."Backorder ID") { Caption = 'Backorder Id'; }
                field(wooOrderId; Rec."Woo Order ID") { Caption = 'Woo Order Id'; }
                field(wooOrderLineId; Rec."Woo Order Line ID") { Caption = 'Woo Order Line Id'; }
                field(bcSalesLineSystemId; Rec."BC Sales Line System ID") { Caption = 'BC Sales Line System Id'; }
                field(itemNo; Rec."Item No.") { Caption = 'Item No.'; }
                field(variantCode; Rec."Variant Code") { Caption = 'Variant Code'; }
                field(locationCode; Rec."Location Code") { Caption = 'Location Code'; }
                field(unitOfMeasureCode; Rec."Unit of Measure Code") { Caption = 'Unit of Measure Code'; }
                field(quantity; Rec.Quantity) { Caption = 'Quantity'; }
                field(quantityBase; Rec."Quantity (Base)") { Caption = 'Quantity Base'; }
                field(allocatedQtyBase; Rec."Allocated Qty. (Base)") { Caption = 'Allocated Qty. Base'; }
                field(fulfilledQtyBase; Rec."Fulfilled Qty. (Base)") { Caption = 'Fulfilled Qty. Base'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(correlationId; Rec."Correlation ID") { Caption = 'Correlation Id'; }
            }
        }
    }
}
