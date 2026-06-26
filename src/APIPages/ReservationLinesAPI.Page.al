page 50111 "BCSR Reservation Lines API"
{
    PageType = API;
    Caption = 'BCSR Reservation Lines API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'reservationLine';
    EntitySetName = 'reservationLines';
    SourceTable = "BCSR Reservation Line";
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
                field(reservationLineId; Rec."Reservation Line ID") { Caption = 'Reservation Line Id'; }
                field(reservationId; Rec."Reservation ID") { Caption = 'Reservation Id'; }
                field(wooCartItemKey; Rec."Woo Cart Item Key") { Caption = 'Woo Cart Item Key'; }
                field(wooOrderLineId; Rec."Woo Order Line ID") { Caption = 'Woo Order Line Id'; }
                field(itemNo; Rec."Item No.") { Caption = 'Item No.'; }
                field(variantCode; Rec."Variant Code") { Caption = 'Variant Code'; }
                field(locationCode; Rec."Location Code") { Caption = 'Location Code'; }
                field(unitOfMeasureCode; Rec."Unit of Measure Code") { Caption = 'Unit of Measure Code'; }
                field(quantity; Rec.Quantity) { Caption = 'Quantity'; }
                field(quantityBase; Rec."Quantity (Base)") { Caption = 'Quantity Base'; }
                field(reservedQtyBase; Rec."Reserved Qty. (Base)") { Caption = 'Reserved Qty. Base'; }
                field(backorderQtyBase; Rec."Backorder Qty. (Base)") { Caption = 'Backorder Qty. Base'; }
                field(bucketId; Rec."Bucket ID") { Caption = 'Bucket Id'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(correlationId; Rec."Correlation ID") { Caption = 'Correlation Id'; }
            }
        }
    }
}
