codeunit 50105 "Reservation Install Mgt."
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "BCSR Setup";
        SetupMgt: Codeunit "Reservation Setup Mgt.";
        SchemaVersion: Record "BCSR Schema Version";
    begin
        if not Setup.Get() then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup."Reservation Duration (Min.)" := 15;
            Setup."Enable New Reservations" := true;
            Setup."Enable Backorders" := true;
            Setup."Auto Release Enabled" := true;
            Setup."Pending Order Timeout (Min.)" := 60;
            Setup."Cleanup Batch Size" := 500;
            Setup."Telemetry Enabled" := true;
            Setup."Schema Version" := '2.0.0';
            Setup.Insert(true);
        end;

        if not SchemaVersion.Get('2.0.0') then begin
            SchemaVersion.Init();
            SchemaVersion.Version := '2.0.0';
            SchemaVersion.Notes := 'Production reservation schema installed.';
            SchemaVersion.Insert(true);
        end;

        SetupMgt.ScheduleExpirationJob();
    end;
}
