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
                field("Variant Code"; Rec."Variant Code")
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
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Short name for this option, used to build the auto-generated Description when Bundle Image Mapping rows are bulk-created (e.g. "White + Black + Large").';
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
                field("Is Default"; Rec."Is Default")
                {
                    ApplicationArea = All;
                    ToolTip = 'The option WooCommerce treats as selected for this group before the customer picks anything - mark exactly one option per "Affects Image" group.';
                }
                field("Linked Option Item No."; Rec."Linked Option Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'For a row in a stock-reserving group, the Item No. of the option in a different (usually non-reserving) group that this row should only be shown alongside - e.g. a Dimension row only appears once the matching Table Top finish is selected. Leave blank for a row that is not filtered by another group''s selection.';
                }
            }
        }
    }
}
