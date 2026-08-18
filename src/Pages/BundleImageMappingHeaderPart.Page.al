page 62025 "Bundle Image Map Header Part"
{
    PageType = ListPart;
    SourceTable = "Bundle Image Mapping Header";
    Caption = 'Bundle Image Mappings';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Image URL"; Rec."Image URL")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditConditions)
            {
                ApplicationArea = All;
                Caption = 'Edit Conditions';
                Image = Setup;
                ToolTip = 'Open this rule to add or edit the condition lines that must all match (exactly - across every "Affects Image" component) for this Image URL to apply.';

                trigger OnAction()
                begin
                    Page.Run(Page::"Bundle Image Map Header Card", Rec);
                end;
            }
            action(GenerateAllCombinations)
            {
                ApplicationArea = All;
                Caption = 'Generate All Combinations';
                Image = CreateForm;
                ToolTip = 'Creates one row here (Image URL left blank for you to fill in) for every possible combination across this bundle''s "Affects Image" option groups. Combinations that already exist are skipped.';

                trigger OnAction()
                var
                    GenMgt: Codeunit "BCSR Bundle Combo Gen.";
                begin
                    GenMgt.GenerateAllCombinations(Rec."Bundle Code");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Serial No." := GetNextSerialNo();
    end;

    local procedure GetNextSerialNo(): Integer
    var
        Header: Record "Bundle Image Mapping Header";
    begin
        Header.SetRange("Bundle Code", Rec."Bundle Code");
        if Header.FindLast() then
            exit(Header."Serial No." + 1);
        exit(1);
    end;
}
