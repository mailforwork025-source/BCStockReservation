codeunit 60110 "BCSR Upgrade Mgt."
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Setup: Record "BCSR Setup";
        SchemaVersion: Record "BCSR Schema Version";
        Cue: Record "BCSR Backorder Cue";
        LegacyBundleProduct: Record "Bundle Item Product";
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
            LegacyBundleProduct.SetRange(Quantity, 0);
            if LegacyBundleProduct.FindSet(true) then
                repeat
                    LegacyBundleProduct.Quantity := 1;
                    LegacyBundleProduct.Modify();
                until LegacyBundleProduct.Next() = 0;

            Setup.Get();
            Setup."Schema Version" := '2.2.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.2.0';
            SchemaVersion."Upgraded From" := '2.1.0';
            SchemaVersion.Notes := 'Backfilled Quantity = 1 on existing Bundle Item Product records (field added after initial insert; InitValue does not apply retroactively).';
            SchemaVersion.Insert(true);
        end;

        // v2.3.0 — Bundle Item Option Quantity migration (moved from Bundle Item Product)
        if not SchemaVersion.Get('2.3.0') then begin
            MigrateBundleQuantityToOptionLevel();

            Setup.Get();
            Setup."Schema Version" := '2.3.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.3.0';
            SchemaVersion."Upgraded From" := '2.2.0';
            SchemaVersion.Notes := 'Moved Quantity from Bundle Item Product to Bundle Item Option (per-group). Consistent groups carried their value up; inconsistent groups left at 0 for manual review (e.g. AC-PHB-PL-10254 "leg").';
            SchemaVersion.Insert(true);
        end;

        // v2.4.0 — Bundle Item Product primary key widened to include Variant Code
        if not SchemaVersion.Get('2.4.0') then begin
            Setup.Get();
            Setup."Schema Version" := '2.4.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.4.0';
            SchemaVersion."Upgraded From" := '2.3.0';
            SchemaVersion.Notes := 'Attempted to widen Bundle Item Product''s key to include Variant Code. BC rejected the in-place change; superseded by 2.5.0''s new-table approach.';
            SchemaVersion.Insert(true);
        end;

        // v2.5.0 — Bundle Item Product data moved to new table "Bundle Item
        // Product V2" (62041), which has the wider key. BC rejects both an
        // in-place key change on a live table ("Changing fields for the
        // key 'PK' is not allowed") and renaming one ("Removing tables is
        // not allowed") - 2.4.0's key widening could not actually be
        // applied to the real table, and RenamedFrom did not help either
        // (AL0124, not usable in this context on this runtime). The old
        // table (62004, still named "Bundle Item Product", fields and key
        // completely unchanged) is left in place permanently as inert
        // legacy data - every row is copied across here, and nothing else
        // in the extension reads or writes it going forward.
        if not SchemaVersion.Get('2.5.0') then begin
            MigrateLegacyBundleProducts();

            Setup.Get();
            Setup."Schema Version" := '2.5.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.5.0';
            SchemaVersion."Upgraded From" := '2.4.0';
            SchemaVersion.Notes := 'Bundle Item Product data moved to new table "Bundle Item Product V2" (wider key incl. Variant Code) - key change and rename were both rejected by BC. Old table left unchanged; every row copied across and cleared.';
            SchemaVersion.Insert(true);
        end;

        // v2.6.0 — Reverted: Variant Code approach abandoned. Every real
        // dimension/size option now gets its own genuine Item No. instead
        // of sharing one item across multiple variants, so the wider key
        // is no longer needed. Data moves back from "Bundle Item Product
        // V2" (62041) to the original "Bundle Item Product" (62004),
        // reversing 2.5.0. Both tables stay defined permanently (BC does
        // not allow removing a previously-published table) but only
        // 62004 is read/written by the extension going forward.
        if not SchemaVersion.Get('2.6.0') then begin
            RevertToOriginalBundleProducts();

            Setup.Get();
            Setup."Schema Version" := '2.6.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.6.0';
            SchemaVersion."Upgraded From" := '2.5.0';
            SchemaVersion.Notes := 'Reverted: Variant Code approach abandoned in favor of a distinct Item No. per option. Data moved back from "Bundle Item Product V2" to the original table; V2 cleared.';
            SchemaVersion.Insert(true);
        end;

        // v2.7.0 — Bundle Item Option "Reserves Stock" backfill
        if not SchemaVersion.Get('2.7.0') then begin
            BackfillReservesStock();

            Setup.Get();
            Setup."Schema Version" := '2.7.0';
            Setup.Modify(true);
            SchemaVersion.Init();
            SchemaVersion.Version := '2.7.0';
            SchemaVersion."Upgraded From" := '2.6.0';
            SchemaVersion.Notes := 'Backfilled Reserves Stock = true on every existing Bundle Item Option record (field added after initial insert; InitValue does not apply retroactively) so no existing group''s reservation behavior changes.';
            SchemaVersion.Insert(true);
        end;
    end;

    local procedure BackfillReservesStock()
    var
        BundleOption: Record "Bundle Item Option";
    begin
        BundleOption.SetRange("Reserves Stock", false);
        if BundleOption.FindSet(true) then
            repeat
                BundleOption."Reserves Stock" := true;
                BundleOption.Modify();
            until BundleOption.Next() = 0;
    end;

    local procedure RevertToOriginalBundleProducts()
    var
        NewProduct: Record "Bundle Item Product V2";
        OriginalProduct: Record "Bundle Item Product";
    begin
        if NewProduct.FindSet() then
            repeat
                if not OriginalProduct.Get(NewProduct."Bundle Code", NewProduct."Option Title", NewProduct."Item No.") then begin
                    OriginalProduct.Init();
                    OriginalProduct."Bundle Code" := NewProduct."Bundle Code";
                    OriginalProduct."Option Title" := NewProduct."Option Title";
                    OriginalProduct."Item No." := NewProduct."Item No.";
                    OriginalProduct."Variant Code" := NewProduct."Variant Code";
                    OriginalProduct."Type" := NewProduct."Type";
                    OriginalProduct.Price := NewProduct.Price;
                    OriginalProduct."Color Hex Code" := NewProduct."Color Hex Code";
                    OriginalProduct."Display Label" := NewProduct."Display Label";
                    OriginalProduct."Image URL" := NewProduct."Image URL";
                    OriginalProduct."Is Default" := NewProduct."Is Default";
                    OriginalProduct."Name" := NewProduct."Name";
                    OriginalProduct.Insert(false);
                end;
            until NewProduct.Next() = 0;

        NewProduct.DeleteAll(false);
    end;

    local procedure MigrateLegacyBundleProducts()
    var
        LegacyProduct: Record "Bundle Item Product";
        NewProduct: Record "Bundle Item Product V2";
    begin
        if LegacyProduct.FindSet() then
            repeat
                if not NewProduct.Get(LegacyProduct."Bundle Code", LegacyProduct."Option Title", LegacyProduct."Item No.", LegacyProduct."Variant Code") then begin
                    NewProduct.Init();
                    NewProduct."Bundle Code" := LegacyProduct."Bundle Code";
                    NewProduct."Option Title" := LegacyProduct."Option Title";
                    NewProduct."Item No." := LegacyProduct."Item No.";
                    NewProduct."Variant Code" := LegacyProduct."Variant Code";
                    NewProduct."Type" := LegacyProduct."Type";
                    NewProduct.Price := LegacyProduct.Price;
                    NewProduct."Color Hex Code" := LegacyProduct."Color Hex Code";
                    NewProduct."Display Label" := LegacyProduct."Display Label";
                    NewProduct."Image URL" := LegacyProduct."Image URL";
                    NewProduct."Is Default" := LegacyProduct."Is Default";
                    NewProduct."Name" := LegacyProduct."Name";
                    NewProduct.Insert(false);
                end;
            until LegacyProduct.Next() = 0;

        LegacyProduct.DeleteAll(false);
    end;

    local procedure MigrateBundleQuantityToOptionLevel()
    var
        BundleOption: Record "Bundle Item Option";
        BundleProduct: Record "Bundle Item Product";
        GroupQty: Decimal;
        Consistent: Boolean;
        FirstReal: Boolean;
    begin
        if BundleOption.FindSet(true) then
            repeat
                BundleProduct.Reset();
                BundleProduct.SetRange("Bundle Code", BundleOption."Bundle Code");
                BundleProduct.SetRange("Option Title", BundleOption."Option Title");
                BundleProduct.SetFilter("Item No.", '<>%1', '');

                GroupQty := 0;
                Consistent := true;
                FirstReal := true;
                if BundleProduct.FindSet() then
                    repeat
                        if FirstReal then begin
                            GroupQty := BundleProduct.Quantity;
                            FirstReal := false;
                        end else
                            if BundleProduct.Quantity <> GroupQty then
                                Consistent := false;
                    until BundleProduct.Next() = 0;

                // Only carry the value up when every real product in the group
                // agrees - an inconsistent group is left at 0 (needs manual
                // review) rather than guessed, per explicit decision on the
                // one real conflict found (AC-PHB-PL-10254 "leg").
                if Consistent and (not FirstReal) then begin
                    BundleOption.Quantity := GroupQty;
                    BundleOption.Modify();
                end;
            until BundleOption.Next() = 0;
    end;
}
