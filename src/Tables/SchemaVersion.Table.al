table 50109 "BCSR Schema Version"
{
    Caption = 'BCSR Schema Version';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; Version; Code[20]) { Caption = 'Version'; }
        field(10; "Installed At"; DateTime) { Caption = 'Installed At'; }
        field(20; "Upgraded From"; Code[20]) { Caption = 'Upgraded From'; }
        field(30; Notes; Text[250]) { Caption = 'Notes'; }
    }

    keys
    {
        key(PK; Version) { Clustered = true; }
        key(InstalledAt; "Installed At") { }
    }

    trigger OnInsert()
    begin
        if "Installed At" = 0DT then
            "Installed At" := CurrentDateTime;
    end;
}
