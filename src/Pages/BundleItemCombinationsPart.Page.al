page 52015 "Bundle Item Combinations Part"
{
    PageType = ListPart;
    SourceTable = "Bundle Item Combination";
    Caption = 'Bundle Item Combinations';

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
                field("Option 1 Type"; Rec."Option 1 Type")
                {
                    ApplicationArea = All;
                }
                field("Option 1 Title"; Rec."Option 1 Title")
                {
                    ApplicationArea = All;
                }
                field("Option 1 Value"; Rec."Option 1 Value")
                {
                    ApplicationArea = All;
                }
                field("Option 2 Type"; Rec."Option 2 Type")
                {
                    ApplicationArea = All;
                }
                field("Option 2 Title"; Rec."Option 2 Title")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
