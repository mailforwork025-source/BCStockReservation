codeunit 50110 "BCSR Upgrade Mgt."
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Setup: Record "BCSR Setup";
        SchemaVersion: Record "BCSR Schema Version";
        Cue: Record "BCSR Backorder Cue";
        BundleProduct: Record "Bundle Item Product";
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

        // v2.1.0 — Backorder Cue singleton backfill
        if not SchemaVersion.Get('2.1.0') then begin
            if not Cue.Get() then begin
                Cue.Init();
                Cue."Primary Key" := '';
                Cue.Insert(true);
            end;
            Setup.Get();
            Setup."Schema Version" := '2.1.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.1.0';
            SchemaVersion."Upgraded From" := '2.0.0';
            SchemaVersion.Notes := 'Added Backorder Cue singleton for Role Center dashboard tile.';
            SchemaVersion.Insert(true);
        end;

        // v2.2.0 — Bundle Item Product Quantity backfill
        if not SchemaVersion.Get('2.2.0') then begin
            BundleProduct.SetRange(Quantity, 0);
            if BundleProduct.FindSet(true) then
                repeat
                    BundleProduct.Quantity := 1;
                    BundleProduct.Modify();
                until BundleProduct.Next() = 0;

            Setup.Get();
            Setup."Schema Version" := '2.2.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.2.0';
            SchemaVersion."Upgraded From" := '2.1.0';
            SchemaVersion.Notes := 'Backfilled Quantity = 1 on existing Bundle Item Product records (field added after initial insert; InitValue does not apply retroactively).';
            SchemaVersion.Insert(true);
        end;
    end;
}
