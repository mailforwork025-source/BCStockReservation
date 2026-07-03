pageextension 50125 "Item Card Reservation Ext." extends "Item Card"
{
    layout
    {
        addafter(Inventory)
        {
            group(StockReservation)
            {
                Caption = 'WooCommerce Stock Reservation';

                field("Reserved Qty"; ReservedQty)
                {
                    ApplicationArea = All;
                    Caption = 'WooCommerce Reserved Qty.';
                    Editable = false;
                    ToolTip = 'Quantity currently reserved by WooCommerce cart sessions. Separate from, and not included in, the standard Reserved Quantity field.';
                }
                field("Available Qty"; AvailableQty)
                {
                    ApplicationArea = All;
                    Caption = 'WooCommerce Available Qty.';
                    Editable = false;
                    ToolTip = 'Quantity available for new WooCommerce reservations, after subtracting WooCommerce holds and standard Business Central sales order reservations.';
                }
                field("Backordered Qty"; BackorderedQty)
                {
                    ApplicationArea = All;
                    Caption = 'WooCommerce Backordered Qty.';
                    Editable = false;
                    ToolTip = 'Quantity on open WooCommerce backorders.';
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
