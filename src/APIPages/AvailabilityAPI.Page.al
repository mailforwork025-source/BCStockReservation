page 50112 "BCSR Availability API"
{
    PageType = API;
    Caption = 'BCSR Availability API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'availabilityBucket';
    EntitySetName = 'availabilityBuckets';
    SourceTable = "BCSR Availability Bucket";
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
                field(bucketId; Rec."Bucket ID") { Caption = 'Bucket Id'; }
                field(itemNo; Rec."Item No.") { Caption = 'Item No.'; }
                field(variantCode; Rec."Variant Code") { Caption = 'Variant Code'; }
                field(locationCode; Rec."Location Code") { Caption = 'Location Code'; }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure") { Caption = 'Base Unit of Measure'; }
                field(physicalQty; Rec."Physical Qty.") { Caption = 'Physical Qty.'; }
                field(reservedQty; Rec."Reserved Qty.") { Caption = 'Reserved Qty.'; }
                field(pendingOrderQty; Rec."Pending Order Qty.") { Caption = 'Pending Order Qty.'; }
                field(backorderQty; Rec."Backorder Qty.") { Caption = 'Backorder Qty.'; }
                field(lastRecalculated; Rec."Last Recalculated") { Caption = 'Last Recalculated'; }
            }
        }
    }
}
