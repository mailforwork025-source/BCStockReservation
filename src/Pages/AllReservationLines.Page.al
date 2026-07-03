page 50119 "BCSR All Reservation Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Reservation Line";
    Caption = 'All Reservation Lines';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Reservation ID"; Rec."Reservation ID") { ApplicationArea = All; }
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Variant Code"; Rec."Variant Code") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)") { ApplicationArea = All; }
                field("Backorder Qty. (Base)"; Rec."Backorder Qty. (Base)") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
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

                trigger OnAction()
                var
                    Header: Record "BCSR Reservation Header";
                begin
                    Header.SetRange("Reservation ID", Rec."Reservation ID");
                    Page.Run(Page::"BCSR Reservation Card", Header);
                end;
            }
        }
    }
}
