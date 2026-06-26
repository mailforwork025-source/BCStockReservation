table 50104 "BCSR Operation Log"
{
    Caption = 'BCSR Operation Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Operation ID"; Guid) { Caption = 'Operation ID'; }
        field(10; "Idempotency Key"; Text[150]) { Caption = 'Idempotency Key'; }
        field(20; "Operation Type"; Text[30]) { Caption = 'Operation Type'; }
        field(30; "Request Hash"; Text[250]) { Caption = 'Request Hash'; }
        field(40; "Request Payload"; Text[2048]) { Caption = 'Request Payload'; }
        field(50; "Response Payload"; Text[2048]) { Caption = 'Response Payload'; }
        field(60; Status; Enum "BCSR Operation Status") { Caption = 'Status'; }
        field(70; "HTTP Status"; Integer) { Caption = 'HTTP Status'; }
        field(80; "Error Code"; Text[50]) { Caption = 'Error Code'; }
        field(90; "Error Message"; Text[250]) { Caption = 'Error Message'; }
        field(100; "Correlation ID"; Text[100]) { Caption = 'Correlation ID'; }
        field(110; "Related Reservation ID"; Guid) { Caption = 'Related Reservation ID'; }
        field(120; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
        field(130; "Completed DateTime"; DateTime) { Caption = 'Completed DateTime'; }
    }

    keys
    {
        key(PK; "Operation ID") { Clustered = true; }
        key(Idempotency; "Idempotency Key") { Unique = true; }
        key(TypeCreated; "Operation Type", "Created DateTime") { }
        key(StatusCreated; Status, "Created DateTime") { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Operation ID") then
            "Operation ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
    end;
}
