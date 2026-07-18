page 52001 "Bundle Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Bundle Header";
    Caption = 'Bundle Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
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
            part(Components; "Bundle Components Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Bundle Code");
                UpdatePropagation = Both;
            }
        }
    }
}
