page 50105 "BCSR Failure Queue"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Failure Queue";
    Caption = 'BCSR Failure Queue';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Failure ID"; Rec."Failure ID") { ApplicationArea = All; }
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

    actions
    {
        area(Processing)
        {
            action(RetryNow)
            {
                ApplicationArea = All;
                Caption = 'Retry Now';
                Image = Restore;
                Enabled = (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::RetryScheduled);
                ToolTip = 'Schedule this failure for immediate retry by the job queue.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::RetryScheduled;
                    Rec."Next Retry DateTime" := CurrentDateTime;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(MarkResolved)
            {
                ApplicationArea = All;
                Caption = 'Mark Resolved';
                Image = Approve;
                Enabled = (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::RetryScheduled);
                ToolTip = 'Mark this failure as resolved, e.g. after fixing it manually in the source system.';

                trigger OnAction()
                begin
                    if Confirm(MarkResolvedConfirmMsg, false) then begin
                        Rec.Status := Rec.Status::Resolved;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(IgnoreFailure)
            {
                ApplicationArea = All;
                Caption = 'Ignore';
                Image = Cancel;
                Enabled = (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::RetryScheduled);
                ToolTip = 'Stop retrying this failure without marking it resolved.';

                trigger OnAction()
                begin
                    if Confirm(IgnoreConfirmMsg, false) then begin
                        Rec.Status := Rec.Status::Ignored;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        MarkResolvedConfirmMsg: Label 'Mark this failure as resolved? This does not retry or undo anything automatically.';
        IgnoreConfirmMsg: Label 'Stop retrying this failure?';
}
