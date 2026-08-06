report 60130 "BCSR Bulk Enable Reservation"
{
    ApplicationArea = All;
    Caption = 'Bulk Enable Stock Reservation & Backorder';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            begin
                if Item."BCSR Enable Reservation" and Item."BCSR Enable Backorder" then
                    exit;

                Item."BCSR Enable Reservation" := true;
                Item."BCSR Enable Backorder" := true;
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
                        Caption = 'This will turn ON stock reservation and backorder for all items. Click OK to proceed.';
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
