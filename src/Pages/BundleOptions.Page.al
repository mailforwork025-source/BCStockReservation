page 52013 "Bundle Options"
{
    PageType = List;
    SourceTable = "Bundle Option";
    Caption = 'Bundle Options';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Bundle Code"; Rec."Bundle Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Component Code"; Rec."Component Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Option Code"; Rec."Option Code")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
