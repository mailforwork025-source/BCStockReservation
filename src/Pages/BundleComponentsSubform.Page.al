page 52002 "Bundle Components Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Bundle Component";
    Caption = 'Bundle Components';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number of the component.';
                }
                field("Component Group Name"; Rec."Component Group Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the group name of the component, e.g., Wheels.';
                }
                field("Quantity Required"; Rec."Quantity Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the component required for the bundle.';
                }
                field("Is Required"; Rec."Is Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this component is required for the bundle.';
                }
                field("Display Order"; Rec."Display Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the display order of the component in the configurator.';
                }
            }
        }
    }
}
