page 50105 "BCSR Failure Queue"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Failure Queue";
    Caption = 'BCSR Failure Queue';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Failure ID"; Rec."Failure ID") { ApplicationArea = All; Editable = false; }
                field("Failure Type"; Rec."Failure Type") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Related Reservation ID"; Rec."Related Reservation ID") { ApplicationArea = All; }
                field("Related Backorder ID"; Rec."Related Backorder ID") { ApplicationArea = All; }
                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Retry Count"; Rec."Retry Count") { ApplicationArea = All; }
                field("Next Retry DateTime"; Rec."Next Retry DateTime") { ApplicationArea = All; }
                field("Last Error"; Rec."Last Error") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
            }
        }
    }
}
