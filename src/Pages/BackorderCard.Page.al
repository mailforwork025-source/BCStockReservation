page 50118 "BCSR Backorder Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "BCSR Backorder Header";
    Caption = 'Backorder Card';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Backorder ID"; Rec."Backorder ID") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Modified DateTime"; Rec."Modified DateTime") { ApplicationArea = All; }
            }
            group(WooCommerce)
            {
                Caption = 'WooCommerce';

                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Woo Order No."; Rec."Woo Order No.") { ApplicationArea = All; }
            }
            group(BusinessCentral)
            {
                Caption = 'Business Central';

                field("BC Sales Order No."; Rec."BC Sales Order No.") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
            }
            part(Lines; "BCSR Backorder Lines Part")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Backorder ID" = field("Backorder ID");
            }
        }
    }
}
