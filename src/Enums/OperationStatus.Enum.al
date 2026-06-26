enum 50102 "BCSR Operation Status"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Completed)
    {
        Caption = 'Completed';
    }
    value(2; Failed)
    {
        Caption = 'Failed';
    }
    value(3; Conflict)
    {
        Caption = 'Conflict';
    }
}
