page 62024 "Bundle Image Map Header Card"
{
    PageType = Card;
    SourceTable = "Bundle Image Mapping Header";
    Caption = 'Bundle Image Mapping Rule';

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
                field("Image URL"; Rec."Image URL")
                {
                    ApplicationArea = All;
                }
            }
            part("Lines"; "Bundle Image Map Lines Part")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Bundle Code"), "Serial No." = field("Serial No.");
                Caption = 'Conditions';
            }
        }
    }
}
