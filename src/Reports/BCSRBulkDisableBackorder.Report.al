report 60133 "BCSR Bulk Disable Backorder"
{
    ApplicationArea = All;
    Caption = 'Bulk Disable Backorder';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            begin
                if not Item."BCSR Enable Backorder" then
                    exit;

                Item."BCSR Enable Backorder" := false;
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
                        Caption = 'This will turn OFF backorder for all items - orders exceeding available stock will no longer be allowed through. Reservation settings are not affected. Click OK to proceed.';
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
