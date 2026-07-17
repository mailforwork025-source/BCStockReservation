codeunit 50199 "BCSR Test API Diag"
{
    
    [ServiceEnabled]

    procedure Ping(): Text
    begin
        Message(
            'UserId=%1\CurrentCompany=%2',
            UserId(),
            CompanyName());

        exit('PONG');
    end;

    // TEMP DIAGNOSTIC - remove after the field ID renumber's data-loss check is closed out.
    [ServiceEnabled]
    procedure DiagListReservationBackorderEnabledItems(): Text
    var
        Item: Record Item;
        ReservationItems: Text;
        BackorderItems: Text;
    begin
        Item.Reset();
        Item.SetRange("BCSR Enable Reservation", true);
        if Item.FindSet() then
            repeat
                if ReservationItems <> '' then
                    ReservationItems += ',';
                ReservationItems += '"' + EscapeJson(Item."No.") + '"';
            until Item.Next() = 0;

        Item.Reset();
        Item.SetRange("BCSR Enable Backorder", true);
        if Item.FindSet() then
            repeat
                if BackorderItems <> '' then
                    BackorderItems += ',';
                BackorderItems += '"' + EscapeJson(Item."No.") + '"';
            until Item.Next() = 0;

        exit(
            '{' +
            '"success":true,' +
            '"reservationEnabledItems":[' + ReservationItems + '],' +
            '"backorderEnabledItems":[' + BackorderItems + ']' +
            '}');
    end;

    local procedure EscapeJson(Value: Text): Text
    begin
        exit(Value.Replace('\', '\\').Replace('"', '\"'));
    end;

    // TEMP, ONE-TIME USE - restores "BCSR Enable Reservation"/"BCSR Enable Backorder" values that
    // were reset to false when those fields were renumbered 50121/50122 -> 51003/51004.
    // Remove after this has been run once against the sandbox/production data it targets.
    [ServiceEnabled]
    procedure DiagRestoreReservationBackorderFlags(): Text
    var
        Item: Record Item;
        ReservationItemNos: List of [Code[20]];
        BackorderItemNos: List of [Code[20]];
        NotFoundItemNos: List of [Code[20]];
        NotFoundItems: Text;
        ItemNo: Code[20];
        ReservationUpdatedCount: Integer;
        BackorderUpdatedCount: Integer;
    begin
        ReservationItemNos.Add('AC-PHB-PL-10254');
        ReservationItemNos.Add('AC-POD-PL-10258');
        ReservationItemNos.Add('AC-POD-PL-10288');
        ReservationItemNos.Add('CH-ERG-MT-10234');
        ReservationItemNos.Add('CH-ERG-MT-10243');
        ReservationItemNos.Add('CH-EXC-AK-10211');
        ReservationItemNos.Add('CH-EXC-AO-10142');
        ReservationItemNos.Add('DT-EXD-CL-10044');
        ReservationItemNos.Add('DT-EXD-GW-10028');
        ReservationItemNos.Add('DT-EXD-PG-10004');
        ReservationItemNos.Add('DT-EXD-PG-10038');
        ReservationItemNos.Add('DT-WKS-CL-10040');
        ReservationItemNos.Add('ST-CAB-GW-10029');

        BackorderItemNos.Add('AC-PHB-PL-10254');
        BackorderItemNos.Add('AC-POD-PL-10258');
        BackorderItemNos.Add('AC-POD-PL-10288');
        BackorderItemNos.Add('CH-ERG-MT-10234');
        BackorderItemNos.Add('CH-EXC-AK-10211');
        BackorderItemNos.Add('CH-EXC-AO-10142');
        BackorderItemNos.Add('DT-EXD-CL-10044');
        BackorderItemNos.Add('DT-EXD-GW-10028');
        BackorderItemNos.Add('DT-EXD-PG-10004');
        BackorderItemNos.Add('DT-EXD-PG-10038');
        BackorderItemNos.Add('DT-WKS-CL-10040');
        BackorderItemNos.Add('ST-CAB-GW-10029');

        foreach ItemNo in ReservationItemNos do
            if Item.Get(ItemNo) then begin
                Item."BCSR Enable Reservation" := true;
                Item.Modify(true);
                ReservationUpdatedCount += 1;
            end else
                AddIfMissing(NotFoundItemNos, ItemNo);

        foreach ItemNo in BackorderItemNos do
            if Item.Get(ItemNo) then begin
                Item."BCSR Enable Backorder" := true;
                Item.Modify(true);
                BackorderUpdatedCount += 1;
            end else
                AddIfMissing(NotFoundItemNos, ItemNo);

        foreach ItemNo in NotFoundItemNos do begin
            if NotFoundItems <> '' then
                NotFoundItems += ',';
            NotFoundItems += '"' + EscapeJson(ItemNo) + '"';
        end;

        exit(
            '{' +
            '"success":true,' +
            '"reservationFlagsUpdated":' + Format(ReservationUpdatedCount) + ',' +
            '"backorderFlagsUpdated":' + Format(BackorderUpdatedCount) + ',' +
            '"itemsNotFound":[' + NotFoundItems + ']' +
            '}');
    end;

    local procedure AddIfMissing(var ItemNos: List of [Code[20]]; ItemNo: Code[20])
    begin
        if not ItemNos.Contains(ItemNo) then
            ItemNos.Add(ItemNo);
    end;
}