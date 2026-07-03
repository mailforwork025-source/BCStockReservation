permissionset 50100 "BCSR ADMIN"
{
    Assignable = true;
    Caption = 'BC Stock Reservation Admin';

    Permissions =
        tabledata "BCSR Setup" = RIMD,
        tabledata "BCSR Availability Bucket" = RIMD,
        tabledata "BCSR Reservation Header" = RIMD,
        tabledata "BCSR Reservation Line" = RIMD,
        tabledata "BCSR Operation Log" = RIMD,
        tabledata "BCSR Failure Queue" = RIMD,
        tabledata "BCSR Audit Log" = RIMD,
        tabledata "BCSR Backorder Header" = RIMD,
        tabledata "BCSR Backorder Line" = RIMD,
        tabledata "BCSR Schema Version" = RIMD,
        tabledata Item = RIMD,
        table "BCSR Setup" = X,
        table "BCSR Availability Bucket" = X,
        table "BCSR Reservation Header" = X,
        table "BCSR Reservation Line" = X,
        table "BCSR Operation Log" = X,
        table "BCSR Failure Queue" = X,
        table "BCSR Audit Log" = X,
        table "BCSR Backorder Header" = X,
        table "BCSR Backorder Line" = X,
        table "BCSR Schema Version" = X,
        page "Stock Reservation Setup" = X,
        page "Active Reservations" = X,
        page "Reservation History" = X,
        page "BCSR Reservation Card" = X,
        page "BCSR Reservation Lines" = X,
        page "BCSR All Reservation Lines" = X,
        page "Backorder List" = X,
        page "BCSR Backorder Header List" = X,
        page "BCSR Backorder Card" = X,
        page "BCSR Backorder Lines Part" = X,
        page "Inventory Avail. Dashboard" = X,
        page "BCSR Failure Queue" = X,
        page "BCSR Operation Log" = X,
        page "BCSR Audit Log" = X,
        page "BCSR Reservations API" = X,
        page "BCSR Reservation Lines API" = X,
        page "BCSR Availability API" = X,
        page "BCSR Backorders API" = X,
        page "BCSR Backorder Lines API" = X,
        page "BCSR Operations API" = X,
        page "BCSR Failures API" = X,
        codeunit "BCSR Reservation Service" = X,
        codeunit "BCSR Backorder Service" = X,
        codeunit "BCSR API Actions" = X,
        codeunit "BCSR Availability Mgt." = X,
        codeunit "BCSR Idempotency Mgt." = X,
        codeunit "BCSR Audit Mgt." = X,
        codeunit "BCSR Telemetry Mgt." = X,
        codeunit "BCSR Test API Diag" = X;
}

permissionset 50101 "BCSR API"
{
    Assignable = true;
    Caption = 'BC Stock Reservation API';

    Permissions =
        tabledata "BCSR Setup" = R,
        tabledata "BCSR Availability Bucket" = RIMD,
        tabledata "BCSR Reservation Header" = RIMD,
        tabledata "BCSR Reservation Line" = RIMD,
        tabledata "BCSR Operation Log" = RIMD,
        tabledata "BCSR Failure Queue" = RIMD,
        tabledata "BCSR Audit Log" = RIMD,
        tabledata "BCSR Backorder Header" = RIMD,
        tabledata "BCSR Backorder Line" = RIMD,
        codeunit "BCSR API Actions" = X,
        codeunit "BCSR Reservation Service" = X,
        codeunit "BCSR Backorder Service" = X,
        codeunit "BCSR Availability Mgt." = X,
        codeunit "BCSR Idempotency Mgt." = X,
        codeunit "BCSR Audit Mgt." = X,
        codeunit "BCSR Test API" = X,
        codeunit "BCSR Test API Diag" = X,
        tabledata Item = RIMD;

    }
