page 52000 "Bundle List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bundle Header";
    CardPageId = "Bundle Card";
    Caption = 'Bundles';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Bundle Code"; Rec."Bundle Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the bundle.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the bundle.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the bundle.';
                }
                field("Base Price"; Rec."Base Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base price of the bundle if fixed pricing is used.';
                }
            }
        }
    }
}
