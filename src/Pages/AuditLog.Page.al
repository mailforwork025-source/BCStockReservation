page 50107 "BCSR Audit Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "BCSR Audit Log";
    Caption = 'BCSR Audit Log';
    Editable = false;
    SourceTableView = sorting("Created DateTime") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Audit ID"; Rec."Audit ID") { ApplicationArea = All; }
                field("Entity Type"; Rec."Entity Type") { ApplicationArea = All; }
                field("Entity ID"; Rec."Entity ID") { ApplicationArea = All; }
                field("Event Type"; Rec."Event Type") { ApplicationArea = All; }
                field("From Status"; Rec."From Status") { ApplicationArea = All; }
                field("To Status"; Rec."To Status") { ApplicationArea = All; }
                field(Message; Rec.Message) { ApplicationArea = All; }
                field("Operation ID"; Rec."Operation ID") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
            }
        }
    }
}
