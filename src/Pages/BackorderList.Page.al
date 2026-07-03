page 50103 "Backorder List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Backorder Line";
    Caption = 'Backorder List';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Backorder Line ID"; Rec."Backorder Line ID") { ApplicationArea = All; }
                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Woo Order Line ID"; Rec."Woo Order Line ID") { ApplicationArea = All; }
                field("BC Sales Line System ID"; Rec."BC Sales Line System ID") { ApplicationArea = All; }
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Variant Code"; Rec."Variant Code") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Quantity (Base)"; Rec."Quantity (Base)") { ApplicationArea = All; }
                field("Allocated Qty. (Base)"; Rec."Allocated Qty. (Base)") { ApplicationArea = All; }
                field("Fulfilled Qty. (Base)"; Rec."Fulfilled Qty. (Base)") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenBackorderCard)
            {
                ApplicationArea = All;
                Caption = 'Backorder Card';
                Image = ItemTrackingLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View the WooCommerce order and Business Central sales order this backorder line belongs to.';

                trigger OnAction()
                var
                    Header: Record "BCSR Backorder Header";
                begin
                    Header.SetRange("Backorder ID", Rec."Backorder ID");
                    Page.Run(Page::"BCSR Backorder Card", Header);
                end;
            }
        }
    }
}
