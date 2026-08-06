page 62017 "Bundle Combination Header Card"
{
    PageType = Card;
    SourceTable = "Bundle Combination Header";
    Caption = 'Bundle Combination Rule';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Disabled Component"; Rec."Disabled Component")
                {
                    ApplicationArea = All;
                }
                field("Disabled Option"; Rec."Disabled Option")
                {
                    ApplicationArea = All;
                }
                field("Image URL"; Rec."Image URL")
                {
                    ApplicationArea = All;
                }
            }
            part("Lines"; "Bundle Combination Lines Part")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Bundle Code"), "Serial No." = field("Serial No.");
                Caption = 'Conditions';
            }
        }
    }
}
