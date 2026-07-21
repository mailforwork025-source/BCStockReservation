page 52012 "Bundle Components Subpart"
{
    PageType = ListPart;
    SourceTable = "Bundle Component";
    Caption = 'Components';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Component Code"; Rec."Component Code")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
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
            action(Options)
            {
                ApplicationArea = All;
                Caption = 'Options';
                Image = SetupList;
                ToolTip = 'View or edit the options available for this component.';
                RunObject = Page "Bundle Options";
                RunPageLink = "Bundle Code" = field("Bundle Code"), "Component Code" = field("Component Code");
            }
        }
    }
}
