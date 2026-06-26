table 50106 "BCSR Audit Log"
{
    Caption = 'BCSR Audit Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Audit ID"; Guid) { Caption = 'Audit ID'; }
        field(10; "Entity Type"; Text[30]) { Caption = 'Entity Type'; }
        field(20; "Entity ID"; Guid) { Caption = 'Entity ID'; }
        field(30; "Event Type"; Text[50]) { Caption = 'Event Type'; }
        field(40; "From Status"; Text[30]) { Caption = 'From Status'; }
        field(50; "To Status"; Text[30]) { Caption = 'To Status'; }
        field(60; Message; Text[250]) { Caption = 'Message'; }
        field(70; "Operation ID"; Guid) { Caption = 'Operation ID'; }
        field(80; "Correlation ID"; Text[100]) { Caption = 'Correlation ID'; }
        field(90; "User Security ID"; Guid) { Caption = 'User Security ID'; }
        field(100; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
    }

    keys
    {
        key(PK; "Audit ID") { Clustered = true; }
        key(EntityCreated; "Entity ID", "Created DateTime") { }
        key(EventCreated; "Event Type", "Created DateTime") { }
        key(Correlation; "Correlation ID") { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Audit ID") then
            "Audit ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        if IsNullGuid("User Security ID") then
            "User Security ID" := UserSecurityId();
    end;
}
