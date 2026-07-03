// ONE-OFF CLEANUP — delete this file after running DeleteZeroGuidBucket() once in SandboxProd09072025.
// This codeunit removes the stray zero-GUID bucket (Bucket ID = 00000000-0000-0000-0000-000000000000)
// that was created before CreateGuid() was assigned in GetOrCreateLockedBucket.
// It also deletes any Reservation Lines that referenced the bad bucket.
codeunit 50112 "BCSR Bucket Cleanup"
{
    InherentPermissions = X;

    [ServiceEnabled]
    procedure DeleteZeroGuidBucket(): Text
    var
        Bucket: Record "BCSR Availability Bucket";
        ReservationLine: Record "BCSR Reservation Line";
        ZeroGuid: Guid;
        BucketsDeleted: Integer;
        LinesDeleted: Integer;
    begin
        // Zero-GUID is the default empty Guid value in AL
        Clear(ZeroGuid);

        // 1. Delete any Reservation Lines that point at the bad bucket first
        ReservationLine.SetRange("Bucket ID", ZeroGuid);
        if ReservationLine.FindSet(true) then begin
            repeat
                ReservationLine.Delete(false);
                LinesDeleted += 1;
            until ReservationLine.Next() = 0;
        end;

        // 2. Delete the zero-GUID bucket itself
        if Bucket.Get(ZeroGuid) then begin
            Bucket.Delete(false);
            BucketsDeleted := 1;
        end;

        exit(StrSubstNo('Cleanup complete. Buckets deleted: %1. Reservation lines deleted: %2.', BucketsDeleted, LinesDeleted));
    end;
}
