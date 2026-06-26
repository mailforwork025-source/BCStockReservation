codeunit 50110 "BCSR Upgrade Mgt."
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Setup: Record "BCSR Setup";
        SchemaVersion: Record "BCSR Schema Version";
    begin
        if not Setup.Get() then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup.Insert(true);
        end;

        Setup."Schema Version" := '2.0.0';
        Setup.Modify(true);

        if not SchemaVersion.Get('2.0.0') then begin
            SchemaVersion.Init();
            SchemaVersion.Version := '2.0.0';
            SchemaVersion."Upgraded From" := '1.0.0';
            SchemaVersion.Notes := 'Migrated from prototype schema to production schema.';
            SchemaVersion.Insert(true);
        end;
    end;
}
