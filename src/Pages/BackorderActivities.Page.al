page 51002 "BCSR Backorder Activities"
{
    PageType = CardPart;
    Caption = 'WooCommerce Backorders';
    SourceTable = "BCSR Backorder Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(BackorderCueGroup)
            {
                Caption = 'WooCommerce Backorders';

                field(PendingBackorderCount; Rec."Pending Backorder Count")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Backorders';
                    ToolTip = 'The number of backorder lines waiting to be fulfilled (statuses: Open, Linked To Sales Line, Partially Allocated, Allocated). Click to open the Backorder List filtered to these statuses.';

                    trigger OnDrillDown()
                    var
                        BackorderLine: Record "BCSR Backorder Line";
                    begin
                        BackorderLine.SetFilter(
                            Status, '%1|%2|%3|%4',
                            BackorderLine.Status::Open,
                            BackorderLine.Status::LinkedToSalesLine,
                            BackorderLine.Status::PartiallyAllocated,
                            BackorderLine.Status::Allocated);
                        Page.Run(Page::"Backorder List", BackorderLine);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Cue: Record "BCSR Backorder Cue";
    begin
        if not Cue.Get() then begin
            Cue.Init();
            Cue."Primary Key" := '';
            Cue.Insert(true);
        end;
        Rec := Cue;
        Rec.CalcFields("Pending Backorder Count");
    end;
}
