page 50109 "BCSR Reservation Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "BCSR Reservation Header";
    Caption = 'Reservation Card';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Reservation ID"; Rec."Reservation ID") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Expires At"; Rec."Expires At") { ApplicationArea = All; }
                field("Manual Review Reason"; Rec."Manual Review Reason") { ApplicationArea = All; }
            }
            group(WooCommerce)
            {
                Caption = 'WooCommerce';

                field("Woo Session ID"; Rec."Woo Session ID") { ApplicationArea = All; }
                field("Woo Customer ID"; Rec."Woo Customer ID") { ApplicationArea = All; }
                field("Woo Cart Hash"; Rec."Woo Cart Hash") { ApplicationArea = All; }
                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Woo Order No."; Rec."Woo Order No.") { ApplicationArea = All; }
            }
            group(BusinessCentral)
            {
                Caption = 'Business Central';

                field("BC Sales Order No."; Rec."BC Sales Order No.") { ApplicationArea = All; }
            }
            group(Tracking)
            {
                Caption = 'Tracking';

                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Modified DateTime"; Rec."Modified DateTime") { ApplicationArea = All; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; }
                field("Last Operation ID"; Rec."Last Operation ID") { ApplicationArea = All; }
            }
            part(Lines; "BCSR Reservation Lines")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Reservation ID" = field("Reservation ID");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReleaseReservation)
            {
                ApplicationArea = All;
                Caption = 'Release Reservation';
                Image = Cancel;
                Enabled = (Rec.Status = Rec.Status::Reserved) or (Rec.Status = Rec.Status::PendingOrder) or (Rec.Status = Rec.Status::ManualReview);

                trigger OnAction()
                var
                    ReservationService: Codeunit "BCSR Reservation Service";
                    ResponsePayload: Text;
                begin
                    if not Confirm(ReleaseConfirmMsg, false) then
                        exit;
                    ReservationService.Release(CopyStr(Format(CreateGuid()), 1, 150), CopyStr(Format(CreateGuid()), 1, 100), Rec."Reservation ID", 'ManualRelease', ResponsePayload);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        ReleaseConfirmMsg: Label 'Release this reservation and all of its lines?';
}
