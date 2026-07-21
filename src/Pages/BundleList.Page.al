page 52010 "Bundle List"
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
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the bundle.';
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bundle.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code for this bundle.';
                }
                field("Allow Back Order"; Rec."Allow Back Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the bundle allows back order.';
                }
            }
        }
    }
}
