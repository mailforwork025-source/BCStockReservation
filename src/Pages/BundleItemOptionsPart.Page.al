page 62013 "Bundle Item Options Part"
{
    PageType = ListPart;
    SourceTable = "Bundle Item Option";
    Caption = 'Bundle Item Options';

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
                field("Display Order"; Rec."Display Order")
                {
                    ApplicationArea = All;
                }
                field("Display Style"; Rec."Display Style")
                {
                    ApplicationArea = All;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Qty per Bundle';
                    ToolTip = 'How many units of whichever product is selected in this group are consumed per bundle unit ordered (e.g. 4 for a set of table legs). Applies to every product in the group.';
                }
                field("Affects Image"; Rec."Affects Image")
                {
                    ApplicationArea = All;
                    ToolTip = 'When enabled, this component group is part of the exact-match set that drives the bundle''s main image (via Bundle Image Mapping) - selections in components not marked here never affect the image.';
                }
                field("Hidden From Customer"; Rec."Hidden From Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'When enabled, this group is never shown to the customer at all - its product is a mandatory part of the bundle (e.g. a support/beam that always ships with the base item). Its stock is committed on every order regardless of what the customer selected. Needs exactly one real product in this group, or exactly one marked Is Default if there''s more than one.';
                }
                field("Reserves Stock"; Rec."Reserves Stock")
                {
                    ApplicationArea = All;
                    ToolTip = 'When disabled, this group''s selection is never sent to stock availability/reservation - only recorded for display (e.g. driving the main-photo swap). Use this for a visual-only finish selector whose real stock is reserved through a different group, to avoid reserving the same physical item twice.';
                }
            }
        }
    }
}
