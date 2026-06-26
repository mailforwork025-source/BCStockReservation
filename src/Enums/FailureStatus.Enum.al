enum 50103 "BCSR Failure Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; RetryScheduled)
    {
        Caption = 'Retry Scheduled';
    }
    value(2; Resolved)
    {
        Caption = 'Resolved';
    }
    value(3; Ignored)
    {
        Caption = 'Ignored';
    }
}
