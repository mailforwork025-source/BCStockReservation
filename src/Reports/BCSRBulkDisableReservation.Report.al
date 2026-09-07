report 60131 "BCSR Bulk Disable Reservation"
{
    ApplicationArea = All;
    Caption = 'Bulk Disable Stock Reservation';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            begin
                if not Item."BCSR Enable Reservation" then
                    exit;

                Item."BCSR Enable Reservation" := false;
                Item.Modify(true);
                UpdatedCount += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Instructions)
                {
                    Caption = ' ';
                    label(InfoLabel)
                    {
                        ApplicationArea = All;
                        Caption = 'This will turn OFF stock reservation for all items - customers will no longer have stock held for them at checkout. Backorder settings are not affected. Click OK to proceed.';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Message('%1 item(s) updated.', UpdatedCount);
    end;

    var
        UpdatedCount: Integer;
}
