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
                field("Native Reserved Qty."; Rec."Native Reserved Qty.") { ApplicationArea = All; ToolTip = 'Quantity reserved through standard Business Central sales orders, outside of WooCommerce.'; }
                field("Available Qty."; AvailableQty) { ApplicationArea = All; Caption = 'Available Qty.'; }
                field("Backorder Qty."; Rec."Backorder Qty.") { ApplicationArea = All; }
                field("Last Recalculated"; Rec."Last Recalculated") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Recalculate)
            {
                ApplicationArea = All;
                Caption = 'Recalculate';
                Image = Refresh;
                ToolTip = 'Recalculate physical, reserved and available quantities for this row from current data.';

                trigger OnAction()
                var
                    AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
                begin
                    Rec.LockTable();
                    if Rec.Find() then
                        AvailabilityMgt.RecalculateBucket(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(RecalculateAll)
            {
                ApplicationArea = All;
                Caption = 'Recalculate All';
                Image = RefreshLines;
                ToolTip = 'Recalculate every availability bucket. Figures on this page can go stale between reservation API calls, so run this if you suspect a row is out of date.';

                trigger OnAction()
                var
                    Setup: Record "BCSR Setup";
                    Bucket: Record "BCSR Availability Bucket";
                    AvailabilityMgt: Codeunit "BCSR Availability Mgt.";
                    RecalculatedCount: Integer;
                begin
                    Bucket.LockTable();
                    if Bucket.FindSet(true) then
                        repeat
                            AvailabilityMgt.RecalculateBucket(Bucket);
                            RecalculatedCount += 1;
                        until Bucket.Next() = 0;

                    Setup.GetSetup();
                    Setup."Last Bucket Rebuild" := CurrentDateTime;
                    Setup.Modify(true);

                    CurrPage.Update(false);
                    Message(RecalculatedMsg, RecalculatedCount);
                end;
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
        RecalculatedMsg: Label '%1 bucket(s) recalculated.', Comment = '%1 = Count';
}
