page 52031 "BCSR Delivery Timelines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Delivery Timeline";
    Caption = 'Delivery Timeline Rules';
    CardPageId = "BCSR Delivery Timeline Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("Quantity From"; Rec."Quantity From")
                {
                    ApplicationArea = All;
                }
                field("Quantity To"; Rec."Quantity To")
                {
                    ApplicationArea = All;
                }
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
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
