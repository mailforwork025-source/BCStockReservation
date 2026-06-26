page 50110 "BCSR Reservations API"
{
    PageType = API;
    Caption = 'BCSR Reservations API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'reservation';
    EntitySetName = 'reservations';
    SourceTable = "BCSR Reservation Header";
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
                field(reservationId; Rec."Reservation ID") { Caption = 'Reservation Id'; }
                field(wooSessionId; Rec."Woo Session ID") { Caption = 'Woo Session Id'; }
                field(wooCustomerId; Rec."Woo Customer ID") { Caption = 'Woo Customer Id'; }
                field(wooOrderId; Rec."Woo Order ID") { Caption = 'Woo Order Id'; }
                field(wooOrderNo; Rec."Woo Order No.") { Caption = 'Woo Order No.'; }
                field(bcSalesOrderSystemId; Rec."BC Sales Order System ID") { Caption = 'BC Sales Order System Id'; }
                field(bcSalesOrderNo; Rec."BC Sales Order No.") { Caption = 'BC Sales Order No.'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(expiresAt; Rec."Expires At") { Caption = 'Expires At'; }
                field(correlationId; Rec."Correlation ID") { Caption = 'Correlation Id'; }
                field(manualReviewReason; Rec."Manual Review Reason") { Caption = 'Manual Review Reason'; }
                field(createdDateTime; Rec."Created DateTime") { Caption = 'Created DateTime'; }
                field(modifiedDateTime; Rec."Modified DateTime") { Caption = 'Modified DateTime'; }
            }
        }
    }
}
