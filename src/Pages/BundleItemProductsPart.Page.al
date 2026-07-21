page 52014 "Bundle Item Products Part"
{
    PageType = ListPart;
    SourceTable = "Bundle Item Product";
    Caption = 'Bundle Item Products';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Option Title"; Rec."Option Title")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Price"; Rec."Price")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
