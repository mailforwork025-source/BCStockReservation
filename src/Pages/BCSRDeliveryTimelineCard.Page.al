page 52032 "BCSR Delivery Timeline Card"
{
    PageType = Card;
    SourceTable = "BCSR Delivery Timeline";
    Caption = 'Delivery Timeline Rule';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item that this rule applies to. If blank, it applies to the category or default.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item category that this rule applies to. If blank, it applies to the item or default.';
                }
            }
            group(Criteria)
            {
                field("Quantity From"; Rec."Quantity From")
                {
                    ApplicationArea = All;
                }
                field("Quantity To"; Rec."Quantity To")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Settings)
            {
                field("Delivery Days"; Rec."Delivery Days")
                {
                    ApplicationArea = All;
                }
                field("Priority"; Rec."Priority")
                {
                    ApplicationArea = All;
                }
                field("Active"; Rec."Active")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
