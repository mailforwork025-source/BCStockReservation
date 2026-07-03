page 50101 "Active Reservations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Reservation Header";
    Caption = 'Active Reservations';
    Editable = false;
    SourceTableView = where(Status = filter(Reserved | PendingOrder | ManualReview));

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Reservation ID"; Rec."Reservation ID") { ApplicationArea = All; }
                field("Woo Session ID"; Rec."Woo Session ID") { ApplicationArea = All; }
                field("Woo Customer ID"; Rec."Woo Customer ID") { ApplicationArea = All; }
                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Woo Order No."; Rec."Woo Order No.") { ApplicationArea = All; }
                field("BC Sales Order No."; Rec."BC Sales Order No.") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Expires At"; Rec."Expires At") { ApplicationArea = All; }
                field("Manual Review Reason"; Rec."Manual Review Reason") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenReservationCard)
            {
                ApplicationArea = All;
                Caption = 'Reservation Card';
                Image = ReservationLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View the reservation lines (item, quantity, status) for this reservation.';

                trigger OnAction()
                begin
                    Page.Run(Page::"BCSR Reservation Card", Rec);
                end;
            }
        }
        area(Processing)
        {
            action(ReleaseReservation)
            {
                ApplicationArea = All;
                Caption = 'Release Reservation';
                Image = Cancel;

                trigger OnAction()
                var
                    ReservationService: Codeunit "BCSR Reservation Service";
                    ResponsePayload: Text;
                begin
                    if Confirm(ReleaseConfirmMsg, false) then begin
                        ReservationService.Release(CopyStr(Format(CreateGuid()), 1, 150), CopyStr(Format(CreateGuid()), 1, 100), Rec."Reservation ID", 'ManualRelease', ResponsePayload);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        ReleaseConfirmMsg: Label 'Release this reservation?';
}
