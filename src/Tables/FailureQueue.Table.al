table 50105 "BCSR Failure Queue"
{
    Caption = 'BCSR Failure Queue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Failure ID"; Guid) { Caption = 'Failure ID'; }
        field(10; "Failure Type"; Text[50]) { Caption = 'Failure Type'; }
        field(20; Status; Enum "BCSR Failure Status") { Caption = 'Status'; }
        field(30; "Related Reservation ID"; Guid) { Caption = 'Related Reservation ID'; }
        field(40; "Related Backorder ID"; Guid) { Caption = 'Related Backorder ID'; }
        field(50; "Woo Order ID"; BigInteger) { Caption = 'Woo Order ID'; }
        field(60; "Idempotency Key"; Text[150]) { Caption = 'Idempotency Key'; }
        field(70; Payload; Text[2048]) { Caption = 'Payload'; }
        field(80; "Retry Count"; Integer) { Caption = 'Retry Count'; }
        field(90; "Next Retry DateTime"; DateTime) { Caption = 'Next Retry DateTime'; }
        field(100; "Last Error"; Text[250]) { Caption = 'Last Error'; }
        field(110; "Correlation ID"; Text[100]) { Caption = 'Correlation ID'; }
        field(120; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
        field(130; "Modified DateTime"; DateTime) { Caption = 'Modified DateTime'; }
    }

    keys
    {
        key(PK; "Failure ID") { Clustered = true; }
        key(StatusRetry; Status, "Next Retry DateTime") { }
        key(TypeStatus; "Failure Type", Status) { }
        key(WooOrder; "Woo Order ID") { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Failure ID") then
            "Failure ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        "Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Modified DateTime" := CurrentDateTime;
    end;
}
