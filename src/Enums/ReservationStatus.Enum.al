enum 50100 "BCSR Reservation Status"
{
    Extensible = true;

    value(0; Reserved)
    {
        Caption = 'Reserved';
    }
    value(1; PendingOrder)
    {
        Caption = 'Pending Order';
    }
    value(2; Confirmed)
    {
        Caption = 'Confirmed';
    }
    value(3; Released)
    {
        Caption = 'Released';
    }
    value(4; Expired)
    {
        Caption = 'Expired';
    }
    value(5; Cancelled)
    {
        Caption = 'Cancelled';
    }
    value(6; ManualReview)
    {
        Caption = 'Manual Review';
    }
}
