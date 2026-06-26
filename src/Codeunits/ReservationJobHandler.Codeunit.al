codeunit 50102 "Reservation Job Handler"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ReleaseExpiredReservations();
    end;

    local procedure ReleaseExpiredReservations()
    var
        ReservationMgt: Codeunit "BCSR Reservation Service";
        ReleasedCount: Integer;
    begin
        ReleasedCount := ReservationMgt.ReleaseExpiredReservations();
        if ReleasedCount > 0 then;
    end;
}
