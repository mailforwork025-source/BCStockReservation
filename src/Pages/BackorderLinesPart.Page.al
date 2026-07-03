page 50120 "BCSR Backorder Lines Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BCSR Backorder Line";
    Caption = 'Lines';
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
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Quantity (Base)"; Rec."Quantity (Base)") { ApplicationArea = All; }
                field("Allocated Qty. (Base)"; Rec."Allocated Qty. (Base)") { ApplicationArea = All; }
                field("Fulfilled Qty. (Base)"; Rec."Fulfilled Qty. (Base)") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("BC Sales Line System ID"; Rec."BC Sales Line System ID") { ApplicationArea = All; Visible = false; }
                field("Woo Order Line ID"; Rec."Woo Order Line ID") { ApplicationArea = All; Visible = false; }
            }
        }
    }
}
