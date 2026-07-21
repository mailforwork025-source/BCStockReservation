table 51001 "BCSR Backorder Cue"
{
    Caption = 'BCSR Backorder Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Pending Backorder Count"; Integer)
        {
            Caption = 'Pending Backorders';
            FieldClass = FlowField;
            CalcFormula = count("BCSR Backorder Line"
                where(Status = filter(Open | LinkedToSalesLine | PartiallyAllocated | Allocated)));
            ToolTip = 'The number of backorder lines that are open and not yet fulfilled or cancelled (statuses: Open, Linked To Sales Line, Partially Allocated, Allocated).';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
