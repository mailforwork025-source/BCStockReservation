page 62021 "Bundle Combination Header Part"
{
    PageType = ListPart;
    SourceTable = "Bundle Combination Header";
    Caption = 'Bundle Combinations';
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
                field("Disabled Component"; Rec."Disabled Component")
                {
                    ApplicationArea = All;
                }
                field("Disabled Option"; Rec."Disabled Option")
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
                ToolTip = 'Open this rule to add or edit the condition lines that must all match for the disabled option (or image) to apply.';

                trigger OnAction()
                begin
                    Page.Run(Page::"Bundle Combination Header Card", Rec);
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
        Header: Record "Bundle Combination Header";
    begin
        Header.SetRange("Bundle Code", Rec."Bundle Code");
        if Header.FindLast() then
            exit(Header."Serial No." + 1);
        exit(1);
    end;
}
