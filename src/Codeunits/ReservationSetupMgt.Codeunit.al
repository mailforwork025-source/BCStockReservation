codeunit 50103 "Reservation Setup Mgt."
{
    procedure ScheduleExpirationJob()
    var
        Setup: Record "BCSR Setup";
        JobQueueEntry: Record "Job Queue Entry";
    begin
        Setup.GetSetup();
        if not Setup."Auto Release Enabled" then
            exit;

        if not IsNullGuid(Setup."Job Queue Entry ID") then begin
            if JobQueueEntry.Get(Setup."Job Queue Entry ID") then
                exit;
        end;

        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"Reservation Job Handler";
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."No. of Minutes between Runs" := 5;
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime;
        JobQueueEntry.Insert(true);

        Setup."Job Queue Entry ID" := JobQueueEntry.ID;
        Setup.Modify(true);
    end;
}
