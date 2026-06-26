page 50102 "Reservation History"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "BCSR Reservation Header";
    Caption = 'Reservation History';
    Editable = false;
    SourceTableView = sorting("Created DateTime") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Reservation ID"; Rec."Reservation ID") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Woo Session ID"; Rec."Woo Session ID") { ApplicationArea = All; }
                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Woo Order No."; Rec."Woo Order No.") { ApplicationArea = All; }
                field("BC Sales Order No."; Rec."BC Sales Order No.") { ApplicationArea = All; }
                field("Expires At"; Rec."Expires At") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Modified DateTime"; Rec."Modified DateTime") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
            }
        }
    }
}
