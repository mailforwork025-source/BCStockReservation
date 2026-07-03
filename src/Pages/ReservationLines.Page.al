page 50108 "BCSR Reservation Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BCSR Reservation Line";
    Caption = 'Reservation Lines';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Variant Code"; Rec."Variant Code") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Quantity (Base)"; Rec."Quantity (Base)") { ApplicationArea = All; }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)") { ApplicationArea = All; }
                field("Backorder Qty. (Base)"; Rec."Backorder Qty. (Base)") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Woo Cart Item Key"; Rec."Woo Cart Item Key") { ApplicationArea = All; Visible = false; }
                field("Woo Order Line ID"; Rec."Woo Order Line ID") { ApplicationArea = All; Visible = false; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Modified DateTime"; Rec."Modified DateTime") { ApplicationArea = All; Visible = false; }
                field("Correlation ID"; Rec."Correlation ID") { ApplicationArea = All; Visible = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReleaseLine)
            {
                ApplicationArea = All;
                Caption = 'Release Line';
                Image = Cancel;
                Enabled = (Rec.Status = Rec.Status::Reserved) or (Rec.Status = Rec.Status::PendingOrder) or (Rec.Status = Rec.Status::ManualReview);

                trigger OnAction()
                var
                    ReservationService: Codeunit "BCSR Reservation Service";
                    ResponsePayload: Text;
                begin
                    if not Confirm(ReleaseLineConfirmMsg, false, Rec."Item No.") then
                        exit;
                    ReservationService.ReleaseLine(CopyStr(Format(CreateGuid()), 1, 150), CopyStr(Format(CreateGuid()), 1, 100), Rec."Reservation ID", Rec."Woo Cart Item Key", ResponsePayload);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        ReleaseLineConfirmMsg: Label 'Release the reservation line for item %1?', Comment = '%1 = Item No.';
}
