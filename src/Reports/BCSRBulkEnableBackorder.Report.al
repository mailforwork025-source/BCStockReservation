report 60132 "BCSR Bulk Enable Backorder"
{
    ApplicationArea = All;
    Caption = 'Bulk Enable Backorder';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            begin
                if Item."BCSR Enable Backorder" then
                    exit;

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
                        Caption = 'This will turn ON backorder for all items. Reservation settings are not affected. Click OK to proceed.';
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
