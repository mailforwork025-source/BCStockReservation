codeunit 62040 "BCSR Bundle Combo Gen."
{
    // Bulk-creates Bundle Image Mapping Header/Line rows: one per possible
    // combination across this bundle's "Affects Image" = true option
    // groups. Image URL is always left blank (the client fills that in
    // manually) - Description is auto-built from each selected option's
    // "Name" field. Combinations that already exist (same set of
    // Component=Option pairs, regardless of which Serial No. they live
    // under) are skipped, not re-created, so re-running this is safe.
    procedure GenerateAllCombinations(BundleCode: Code[20])
    var
        BundleOption: Record "Bundle Item Option";
        GroupTitles: List of [Text];
        GroupTitle: Text;
        SelectedItems: List of [Code[20]];
        ExistingSignatures: List of [Text];
        TotalCombinations: Integer;
        GroupCount: Integer;
        CreatedCount: Integer;
        SkippedCount: Integer;
        NoGroupsMsg: Label 'No option groups on this bundle have "Affects Image" set to true. Nothing to generate.';
        EmptyGroupMsg: Label 'Group "%1" has no options defined. Cannot generate combinations until every group has at least one option.', Comment = '%1 = group title';
        ConfirmLbl: Label 'This will generate %1 combination(s) for bundle %2. Continue?', Comment = '%1 = combination count, %2 = bundle code';
        DoneMsg: Label '%1 combination(s) created. %2 already existed and were skipped.', Comment = '%1 = new count, %2 = skipped count';
    begin
        BundleOption.SetRange("Bundle Code", BundleCode);
        BundleOption.SetRange("Affects Image", true);
        if BundleOption.FindSet() then
            repeat
                GroupTitles.Add(BundleOption."Option Title");
            until BundleOption.Next() = 0;

        if GroupTitles.Count() = 0 then begin
            Message(NoGroupsMsg);
            exit;
        end;

        TotalCombinations := 1;
        foreach GroupTitle in GroupTitles do begin
            GroupCount := CountOptionsInGroup(BundleCode, GroupTitle);
            if GroupCount = 0 then begin
                Message(EmptyGroupMsg, GroupTitle);
                exit;
            end;
            TotalCombinations := TotalCombinations * GroupCount;
        end;

        if TotalCombinations > 200 then
            if not Confirm(StrSubstNo(ConfirmLbl, TotalCombinations, BundleCode), false) then
                exit;

        LoadExistingSignatures(BundleCode, GroupTitles, ExistingSignatures);
        GenerateRecursive(BundleCode, GroupTitles, 0, SelectedItems, ExistingSignatures, CreatedCount, SkippedCount);

        Message(DoneMsg, CreatedCount, SkippedCount);
    end;

    local procedure CountOptionsInGroup(BundleCode: Code[20]; GroupTitle: Text): Integer
    var
        Product: Record "Bundle Item Product";
    begin
        Product.SetRange("Bundle Code", BundleCode);
        Product.SetRange("Option Title", CopyStr(GroupTitle, 1, 50));
        exit(Product.Count());
    end;

    local procedure LoadExistingSignatures(BundleCode: Code[20]; GroupTitles: List of [Text]; var ExistingSignatures: List of [Text])
    var
        Header: Record "Bundle Image Mapping Header";
    begin
        Header.SetRange("Bundle Code", BundleCode);
        if Header.FindSet() then
            repeat
                ExistingSignatures.Add(BuildSignatureForExistingHeader(BundleCode, Header."Serial No.", GroupTitles));
            until Header.Next() = 0;
    end;

    local procedure BuildSignatureForExistingHeader(BundleCode: Code[20]; SerialNo: Integer; GroupTitles: List of [Text]): Text
    var
        Line: Record "Bundle Image Mapping Line";
        GroupTitle: Text;
        Signature: Text;
    begin
        foreach GroupTitle in GroupTitles do begin
            Line.Reset();
            Line.SetRange("Bundle Code", BundleCode);
            Line.SetRange("Serial No.", SerialNo);
            Line.SetRange("Component", CopyStr(GroupTitle, 1, 50));
            if Line.FindFirst() then
                Signature += GroupTitle + '=' + Line."Option" + '|'
            else
                Signature += GroupTitle + '=|';
        end;
        exit(Signature);
    end;

    local procedure GenerateRecursive(BundleCode: Code[20]; GroupTitles: List of [Text]; GroupIndex: Integer; var SelectedItems: List of [Code[20]]; var ExistingSignatures: List of [Text]; var CreatedCount: Integer; var SkippedCount: Integer)
    var
        Product: Record "Bundle Item Product";
        GroupTitle: Text;
    begin
        if GroupIndex >= GroupTitles.Count() then begin
            CreateCombinationIfNew(BundleCode, GroupTitles, SelectedItems, ExistingSignatures, CreatedCount, SkippedCount);
            exit;
        end;

        GroupTitle := GroupTitles.Get(GroupIndex + 1);
        Product.SetRange("Bundle Code", BundleCode);
        Product.SetRange("Option Title", CopyStr(GroupTitle, 1, 50));
        if Product.FindSet() then
            repeat
                SelectedItems.Add(Product."Item No.");
                GenerateRecursive(BundleCode, GroupTitles, GroupIndex + 1, SelectedItems, ExistingSignatures, CreatedCount, SkippedCount);
                SelectedItems.RemoveAt(SelectedItems.Count());
            until Product.Next() = 0;
    end;

    local procedure CreateCombinationIfNew(BundleCode: Code[20]; GroupTitles: List of [Text]; SelectedItems: List of [Code[20]]; var ExistingSignatures: List of [Text]; var CreatedCount: Integer; var SkippedCount: Integer)
    var
        Header: Record "Bundle Image Mapping Header";
        Line: Record "Bundle Image Mapping Line";
        Product: Record "Bundle Item Product";
        Signature: Text;
        Description: Text;
        DisplayName: Text;
        i: Integer;
        NextSerialNo: Integer;
    begin
        Signature := '';
        Description := '';
        for i := 1 to GroupTitles.Count() do begin
            Signature += GroupTitles.Get(i) + '=' + SelectedItems.Get(i) + '|';

            Product.Reset();
            Product.SetRange("Bundle Code", BundleCode);
            Product.SetRange("Option Title", CopyStr(GroupTitles.Get(i), 1, 50));
            Product.SetRange("Item No.", SelectedItems.Get(i));
            if Product.FindFirst() then begin
                DisplayName := Product."Name";
                if DisplayName = '' then
                    DisplayName := Product."Item No.";
            end else
                DisplayName := SelectedItems.Get(i);

            if Description <> '' then
                Description += ' + ';
            Description += DisplayName;
        end;

        if ExistingSignatures.Contains(Signature) then begin
            SkippedCount += 1;
            exit;
        end;

        Header.SetRange("Bundle Code", BundleCode);
        if Header.FindLast() then
            NextSerialNo := Header."Serial No." + 1
        else
            NextSerialNo := 1;

        Header.Init();
        Header."Bundle Code" := BundleCode;
        Header."Serial No." := NextSerialNo;
        Header."Description" := CopyStr(Description, 1, 100);
        Header.Insert(true);

        for i := 1 to GroupTitles.Count() do begin
            Line.Init();
            Line."Bundle Code" := BundleCode;
            Line."Serial No." := NextSerialNo;
            Line."Line No." := i;
            Line."Component" := CopyStr(GroupTitles.Get(i), 1, 50);
            Line."Option" := SelectedItems.Get(i);
            Line.Insert(true);
        end;

        ExistingSignatures.Add(Signature);
        CreatedCount += 1;
    end;

    // Bulk-creates Bundle Combination Header/Line rows: one per possible
    // combination across ALL of this bundle's option groups (not just
    // "Affects Image" = true - unlike Image Mapping, a Bundle Combination
    // row can express a blocking rule referencing any group, so scoping
    // this to image-affecting groups only would silently miss real
    // blocking scenarios). Disabled Component/Option and Image URL are
    // always left blank (pure enumeration rows) - the client turns
    // specific rows into real blocking/image rules afterward via the
    // existing "Edit Conditions" flow. Combinations that already exist
    // (same set of Component=Option pairs, regardless of Serial No.) are
    // skipped, not re-created, so re-running this is safe.
    procedure GenerateAllCombinationRules(BundleCode: Code[20])
    var
        BundleOption: Record "Bundle Item Option";
        GroupTitles: List of [Text];
        GroupTitle: Text;
        SelectedItems: List of [Code[20]];
        ExistingSignatures: List of [Text];
        TotalCombinations: Integer;
        GroupCount: Integer;
        CreatedCount: Integer;
        SkippedCount: Integer;
        NoGroupsMsg: Label 'This bundle has no option groups defined. Nothing to generate.';
        EmptyGroupMsg: Label 'Group "%1" has no options defined. Cannot generate combinations until every group has at least one option.', Comment = '%1 = group title';
        ConfirmLbl: Label 'This will generate %1 combination(s) for bundle %2. Continue?', Comment = '%1 = combination count, %2 = bundle code';
        DoneMsg: Label '%1 combination(s) created. %2 already existed and were skipped.', Comment = '%1 = new count, %2 = skipped count';
    begin
        BundleOption.SetRange("Bundle Code", BundleCode);
        if BundleOption.FindSet() then
            repeat
                GroupTitles.Add(BundleOption."Option Title");
            until BundleOption.Next() = 0;

        if GroupTitles.Count() = 0 then begin
            Message(NoGroupsMsg);
            exit;
        end;

        TotalCombinations := 1;
        foreach GroupTitle in GroupTitles do begin
            GroupCount := CountOptionsInGroup(BundleCode, GroupTitle);
            if GroupCount = 0 then begin
                Message(EmptyGroupMsg, GroupTitle);
                exit;
            end;
            TotalCombinations := TotalCombinations * GroupCount;
        end;

        if TotalCombinations > 200 then
            if not Confirm(StrSubstNo(ConfirmLbl, TotalCombinations, BundleCode), false) then
                exit;

        LoadExistingCombinationSignatures(BundleCode, GroupTitles, ExistingSignatures);
        GenerateCombinationRulesRecursive(BundleCode, GroupTitles, 0, SelectedItems, ExistingSignatures, CreatedCount, SkippedCount);

        Message(DoneMsg, CreatedCount, SkippedCount);
    end;

    local procedure LoadExistingCombinationSignatures(BundleCode: Code[20]; GroupTitles: List of [Text]; var ExistingSignatures: List of [Text])
    var
        Header: Record "Bundle Combination Header";
    begin
        Header.SetRange("Bundle Code", BundleCode);
        if Header.FindSet() then
            repeat
                ExistingSignatures.Add(BuildSignatureForExistingCombinationHeader(BundleCode, Header."Serial No.", GroupTitles));
            until Header.Next() = 0;
    end;

    local procedure BuildSignatureForExistingCombinationHeader(BundleCode: Code[20]; SerialNo: Integer; GroupTitles: List of [Text]): Text
    var
        Line: Record "Bundle Combination Line";
        GroupTitle: Text;
        Signature: Text;
    begin
        foreach GroupTitle in GroupTitles do begin
            Line.Reset();
            Line.SetRange("Bundle Code", BundleCode);
            Line.SetRange("Serial No.", SerialNo);
            Line.SetRange("Component", CopyStr(GroupTitle, 1, 50));
            if Line.FindFirst() then
                Signature += GroupTitle + '=' + Line."Option" + '|'
            else
                Signature += GroupTitle + '=|';
        end;
        exit(Signature);
    end;

    local procedure GenerateCombinationRulesRecursive(BundleCode: Code[20]; GroupTitles: List of [Text]; GroupIndex: Integer; var SelectedItems: List of [Code[20]]; var ExistingSignatures: List of [Text]; var CreatedCount: Integer; var SkippedCount: Integer)
    var
        Product: Record "Bundle Item Product";
        GroupTitle: Text;
    begin
        if GroupIndex >= GroupTitles.Count() then begin
            CreateCombinationRuleIfNew(BundleCode, GroupTitles, SelectedItems, ExistingSignatures, CreatedCount, SkippedCount);
            exit;
        end;

        GroupTitle := GroupTitles.Get(GroupIndex + 1);
        Product.SetRange("Bundle Code", BundleCode);
        Product.SetRange("Option Title", CopyStr(GroupTitle, 1, 50));
        if Product.FindSet() then
            repeat
                SelectedItems.Add(Product."Item No.");
                GenerateCombinationRulesRecursive(BundleCode, GroupTitles, GroupIndex + 1, SelectedItems, ExistingSignatures, CreatedCount, SkippedCount);
                SelectedItems.RemoveAt(SelectedItems.Count());
            until Product.Next() = 0;
    end;

    local procedure CreateCombinationRuleIfNew(BundleCode: Code[20]; GroupTitles: List of [Text]; SelectedItems: List of [Code[20]]; var ExistingSignatures: List of [Text]; var CreatedCount: Integer; var SkippedCount: Integer)
    var
        Header: Record "Bundle Combination Header";
        Line: Record "Bundle Combination Line";
        Product: Record "Bundle Item Product";
        Signature: Text;
        Description: Text;
        DisplayName: Text;
        i: Integer;
        NextSerialNo: Integer;
    begin
        Signature := '';
        Description := '';
        for i := 1 to GroupTitles.Count() do begin
            Signature += GroupTitles.Get(i) + '=' + SelectedItems.Get(i) + '|';

            Product.Reset();
            Product.SetRange("Bundle Code", BundleCode);
            Product.SetRange("Option Title", CopyStr(GroupTitles.Get(i), 1, 50));
            Product.SetRange("Item No.", SelectedItems.Get(i));
            if Product.FindFirst() then begin
                DisplayName := Product."Name";
                if DisplayName = '' then
                    DisplayName := Product."Item No.";
            end else
                DisplayName := SelectedItems.Get(i);

            if Description <> '' then
                Description += ' + ';
            Description += DisplayName;
        end;

        if ExistingSignatures.Contains(Signature) then begin
            SkippedCount += 1;
            exit;
        end;

        Header.SetRange("Bundle Code", BundleCode);
        if Header.FindLast() then
            NextSerialNo := Header."Serial No." + 1
        else
            NextSerialNo := 1;

        Header.Init();
        Header."Bundle Code" := BundleCode;
        Header."Serial No." := NextSerialNo;
        Header."Description" := CopyStr(Description, 1, 100);
        Header.Insert(true);

        for i := 1 to GroupTitles.Count() do begin
            Line.Init();
            Line."Bundle Code" := BundleCode;
            Line."Serial No." := NextSerialNo;
            Line."Line No." := i;
            Line."Component" := CopyStr(GroupTitles.Get(i), 1, 50);
            Line."Option" := SelectedItems.Get(i);
            Line.Insert(true);
        end;

        ExistingSignatures.Add(Signature);
        CreatedCount += 1;
    end;
}
