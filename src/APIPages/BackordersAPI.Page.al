page 50113 "BCSR Backorders API"
{
    PageType = API;
    Caption = 'BCSR Backorders API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'backorder';
    EntitySetName = 'backorders';
    SourceTable = "BCSR Backorder Header";
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
                field(backorderId; Rec."Backorder ID") { Caption = 'Backorder Id'; }
                field(wooOrderId; Rec."Woo Order ID") { Caption = 'Woo Order Id'; }
                field(wooOrderNo; Rec."Woo Order No.") { Caption = 'Woo Order No.'; }
                field(bcSalesOrderSystemId; Rec."BC Sales Order System ID") { Caption = 'BC Sales Order System Id'; }
                field(bcSalesOrderNo; Rec."BC Sales Order No.") { Caption = 'BC Sales Order No.'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(correlationId; Rec."Correlation ID") { Caption = 'Correlation Id'; }
                field(createdDateTime; Rec."Created DateTime") { Caption = 'Created DateTime'; }
                field(modifiedDateTime; Rec."Modified DateTime") { Caption = 'Modified DateTime'; }
            }
        }
    }
}
