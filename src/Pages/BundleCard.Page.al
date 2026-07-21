page 52011 "Bundle Card"
{
    PageType = Document;
    SourceTable = "Bundle Header";
    Caption = 'Bundle Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
            }
            part(Components; "Bundle Components Subpart")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Code");
            }
        }
    }
}
