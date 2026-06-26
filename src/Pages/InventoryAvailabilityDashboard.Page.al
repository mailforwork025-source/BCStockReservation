page 50104 "Inventory Avail. Dashboard"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "BCSR Availability Bucket";
    Caption = 'Inventory Availability Dashboard';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field("Variant Code"; Rec."Variant Code") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Base Unit of Measure"; Rec."Base Unit of Measure") { ApplicationArea = All; }
                field("Physical Qty."; Rec."Physical Qty.") { ApplicationArea = All; }
                field("Reserved Qty."; Rec."Reserved Qty.") { ApplicationArea = All; }
                field("Pending Order Qty."; Rec."Pending Order Qty.") { ApplicationArea = All; }
                field("Available Qty."; AvailableQty) { ApplicationArea = All; Caption = 'Available Qty.'; }
                field("Backorder Qty."; Rec."Backorder Qty.") { ApplicationArea = All; }
                field("Last Recalculated"; Rec."Last Recalculated") { ApplicationArea = All; }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
    begin
        AvailableQty := AvailabilityMgt.GetAvailableQtyBase(Rec);
    end;

    var
        AvailableQty: Decimal;
}
