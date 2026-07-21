page 52013 "Bundle Item Options Part"
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
            }
        }
    }
}
