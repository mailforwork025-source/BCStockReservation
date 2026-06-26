page 50116 "BCSR Failures API"
{
    PageType = API;
    Caption = 'BCSR Failures API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'failure';
    EntitySetName = 'failures';
    SourceTable = "BCSR Failure Queue";
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
                field(failureId; Rec."Failure ID") { Caption = 'Failure Id'; }
                field(failureType; Rec."Failure Type") { Caption = 'Failure Type'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(relatedReservationId; Rec."Related Reservation ID") { Caption = 'Related Reservation Id'; }
                field(relatedBackorderId; Rec."Related Backorder ID") { Caption = 'Related Backorder Id'; }
                field(wooOrderId; Rec."Woo Order ID") { Caption = 'Woo Order Id'; }
                field(retryCount; Rec."Retry Count") { Caption = 'Retry Count'; }
                field(nextRetryDateTime; Rec."Next Retry DateTime") { Caption = 'Next Retry DateTime'; }
                field(lastError; Rec."Last Error") { Caption = 'Last Error'; }
                field(correlationId; Rec."Correlation ID") { Caption = 'Correlation Id'; }
                field(createdDateTime; Rec."Created DateTime") { Caption = 'Created DateTime'; }
            }
        }
    }
}
