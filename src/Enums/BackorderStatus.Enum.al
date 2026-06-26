enum 50101 "BCSR Backorder Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; LinkedToSalesLine)
    {
        Caption = 'Linked To Sales Line';
    }
    value(2; PartiallyAllocated)
    {
        Caption = 'Partially Allocated';
    }
    value(3; Allocated)
    {
        Caption = 'Allocated';
    }
    value(4; Fulfilled)
    {
        Caption = 'Fulfilled';
    }
    value(5; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
