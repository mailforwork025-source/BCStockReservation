report 60134 "BCSR Bulk Enable Resrv. Only"
{
    // Reservation-only counterpart to "BCSR Bulk Disable Reservation"
    // (report 60131). The pre-existing "BCSR Bulk Enable Reservation"
    // (report 60130) turns on Reservation AND Backorder together, which
    // isn't a true toggle pair with 60131 - this one is left alongside it,
    // untouched, so nothing that already uses 60130 changes behavior.
    ApplicationArea = All;
    Caption = 'Bulk Enable Stock Reservation (Only)';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            begin
                if Item."BCSR Enable Reservation" then
                    exit;

                Item."BCSR Enable Reservation" := true;
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
                        Caption = 'This will turn ON stock reservation for all items. Backorder settings are not affected. Click OK to proceed.';
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
