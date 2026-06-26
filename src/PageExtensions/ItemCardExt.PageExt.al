pageextension 50125 "Item Card Reservation Ext." extends "Item Card"
{
    layout
    {
        addafter(Inventory)
        {
            group(StockReservation)
            {
                Caption = 'Stock Reservation';

                field("Reserved Qty"; ReservedQty)
                {
                    ApplicationArea = All;
                    Caption = 'Reserved Quantity';
                    Editable = false;
                    ToolTip = 'Quantity currently reserved by WooCommerce cart sessions.';
                }
                field("Available Qty"; AvailableQty)
                {
                    ApplicationArea = All;
                    Caption = 'Available Quantity';
                    Editable = false;
                    ToolTip = 'Quantity available for new reservations.';
                }
                field("Backordered Qty"; BackorderedQty)
                {
                    ApplicationArea = All;
                    Caption = 'Backordered Quantity';
                    Editable = false;
                    ToolTip = 'Quantity on open backorders.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Setup: Record "BCSR Setup";
        Bucket: Record "BCSR Availability Bucket";
        AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
    begin
        Setup.GetSetup();
        if Setup."Website Location Code" = '' then begin
            ReservedQty := 0;
            AvailableQty := 0;
            BackorderedQty := 0;
            exit;
        end;
        AvailabilityMgt.GetOrCreateLockedBucket(Rec."No.", '', Setup."Website Location Code", Bucket);
        AvailabilityMgt.RecalculateBucket(Bucket);
        ReservedQty := Bucket."Reserved Qty." + Bucket."Pending Order Qty.";
        AvailableQty := AvailabilityMgt.GetAvailableQtyBase(Bucket);
        BackorderedQty := Bucket."Backorder Qty.";
    end;

    var
        ReservedQty: Decimal;
        AvailableQty: Decimal;
        BackorderedQty: Decimal;
}
