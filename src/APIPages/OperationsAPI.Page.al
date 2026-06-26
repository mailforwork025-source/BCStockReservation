page 50115 "BCSR Operations API"
{
    PageType = API;
    Caption = 'BCSR Operations API';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v2.0';
    EntityName = 'operation';
    EntitySetName = 'operations';
    SourceTable = "BCSR Operation Log";
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
                field(operationId; Rec."Operation ID") { Caption = 'Operation Id'; }
                field(idempotencyKey; Rec."Idempotency Key") { Caption = 'Idempotency Key'; }
                field(operationType; Rec."Operation Type") { Caption = 'Operation Type'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(httpStatus; Rec."HTTP Status") { Caption = 'HTTP Status'; }
                field(errorCode; Rec."Error Code") { Caption = 'Error Code'; }
                field(errorMessage; Rec."Error Message") { Caption = 'Error Message'; }
                field(correlationId; Rec."Correlation ID") { Caption = 'Correlation Id'; }
                field(createdDateTime; Rec."Created DateTime") { Caption = 'Created DateTime'; }
                field(completedDateTime; Rec."Completed DateTime") { Caption = 'Completed DateTime'; }
            }
        }
    }
}
