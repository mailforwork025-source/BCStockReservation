page 50106 "BCSR Operation Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "BCSR Operation Log";
    Caption = 'BCSR Operation Log';
    Editable = false;
    SourceTableView = sorting("Created DateTime") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Operation ID"; Rec."Operation ID") { ApplicationArea = All; }
                field("Idempotency Key"; Rec."Idempotency Key") { ApplicationArea = All; }
                field("Operation Type"; Rec."Operation Type") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("HTTP Status"; Rec."HTTP Status") { ApplicationArea = All; }
                field("Error Code"; Rec."Error Code") { ApplicationArea = All; }
                field("Error Message"; Rec."Error Message") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
                field("Related Reservation ID"; Rec."Related Reservation ID") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Completed DateTime"; Rec."Completed DateTime") { ApplicationArea = All; }
            }
        }
    }
}
