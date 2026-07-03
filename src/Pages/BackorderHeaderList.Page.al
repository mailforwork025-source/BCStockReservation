page 50117 "BCSR Backorder Header List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BCSR Backorder Header";
    Caption = 'Backorder Header List';
    Editable = false;
    SourceTableView = sorting("Created DateTime") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Backorder ID"; Rec."Backorder ID") { ApplicationArea = All; }
                field("Woo Order ID"; Rec."Woo Order ID") { ApplicationArea = All; }
                field("Woo Order No."; Rec."Woo Order No.") { ApplicationArea = All; }
                field("BC Sales Order No."; Rec."BC Sales Order No.") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Modified DateTime"; Rec."Modified DateTime") { ApplicationArea = All; }
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
                ToolTip = 'View the backorder lines (item, quantity, status) for this WooCommerce order.';

                trigger OnAction()
                begin
                    Page.Run(Page::"BCSR Backorder Card", Rec);
                end;
            }
        }
    }
}
