page 62014 "Bundle Item Products Part"
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
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Qty per Bundle';
                    ToolTip = 'How many units of this component are consumed per bundle unit ordered (e.g. 4 for a set of table legs).';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Color Hex Code"; Rec."Color Hex Code")
                {
                    ApplicationArea = All;
                }
                field("Display Label"; Rec."Display Label")
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
}
