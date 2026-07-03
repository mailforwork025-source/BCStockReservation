page 50100 "Stock Reservation Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BCSR Setup";
    Caption = 'Stock Reservation Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Enable New Reservations"; Rec."Enable New Reservations") { ApplicationArea = All; }
                field("Enable Backorders"; Rec."Enable Backorders") { ApplicationArea = All; }
                field("Reservation Duration (Min.)"; Rec."Reservation Duration (Min.)") { ApplicationArea = All; }
                field("Pending Order Timeout (Min.)"; Rec."Pending Order Timeout (Min.)") { ApplicationArea = All; }
                field("Website Location Code"; Rec."Website Location Code") { ApplicationArea = All; }
                field("Auto Release Enabled"; Rec."Auto Release Enabled") { ApplicationArea = All; }
                field("Cleanup Batch Size"; Rec."Cleanup Batch Size") { ApplicationArea = All; }
                field("Telemetry Enabled"; Rec."Telemetry Enabled") { ApplicationArea = All; }
                field("Schema Version"; Rec."Schema Version") { ApplicationArea = All; Editable = false; }
                field("Last Bucket Rebuild"; Rec."Last Bucket Rebuild") { ApplicationArea = All; Editable = false; }
                field("Job Queue Entry ID"; Rec."Job Queue Entry ID") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ScheduleExpirationJob)
            {
                ApplicationArea = All;
                Caption = 'Schedule Expiration Job';
                Image = JobListSetup;

                trigger OnAction()
                var
                    SetupMgt: Codeunit "Reservation Setup Mgt.";
                begin
                    SetupMgt.ScheduleExpirationJob();
                    CurrPage.Update(false);
                    Message(JobScheduledMsg);
                end;
            }
            action(ReleaseExpiredNow)
            {
                ApplicationArea = All;
                Caption = 'Release Expired Now';
                Image = ReleaseShipment;

                trigger OnAction()
                var
                    ReservationService: Codeunit "BCSR Reservation Service";
                    ReleasedCount: Integer;
                begin
                    ReleasedCount := ReservationService.ReleaseExpiredReservations();
                    Message(ReleasedMsg, ReleasedCount);
                end;
            }
        }
        area(Navigation)
        {
            action(ActiveReservations) { ApplicationArea = All; Caption = 'Active Reservations'; RunObject = page "Active Reservations"; Image = ReservationLedger; }
            action(ReservationHistory) { ApplicationArea = All; Caption = 'Reservation History'; RunObject = page "Reservation History"; Image = History; }
            action(BackorderList) { ApplicationArea = All; Caption = 'Backorder List'; RunObject = page "Backorder List"; Image = ItemTrackingLedger; }
            action(BackorderHeaderList) { ApplicationArea = All; Caption = 'Backorder Header List'; RunObject = page "BCSR Backorder Header List"; Image = ItemTrackingLedger; }
            action(InventoryDashboard) { ApplicationArea = All; Caption = 'Inventory Availability Dashboard'; RunObject = page "Inventory Avail. Dashboard"; Image = ItemAvailability; }
            action(FailureQueue) { ApplicationArea = All; Caption = 'Failure Queue'; RunObject = page "BCSR Failure Queue"; Image = ErrorLog; }
            action(OperationLog) { ApplicationArea = All; Caption = 'Operation Log'; RunObject = page "BCSR Operation Log"; Image = Log; }
            action(AuditLog) { ApplicationArea = All; Caption = 'Audit Log'; RunObject = page "BCSR Audit Log"; Image = History; }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert(true);
        end;
    end;

    var
        JobScheduledMsg: Label 'Expiration job has been scheduled.';
        ReleasedMsg: Label '%1 expired reservation(s) have been released.', Comment = '%1 = Count';
}
