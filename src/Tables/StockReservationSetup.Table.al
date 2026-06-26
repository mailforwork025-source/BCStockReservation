table 50100 "BCSR Setup"
{
    Caption = 'BC Stock Reservation Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Reservation Duration (Min.)"; Integer)
        {
            Caption = 'Reservation Duration (Min.)';
            InitValue = 15;
            MinValue = 1;
            MaxValue = 1440;
        }
        field(20; "Enable New Reservations"; Boolean)
        {
            Caption = 'Enable New Reservations';
            InitValue = true;
        }
        field(30; "Enable Backorders"; Boolean)
        {
            Caption = 'Enable Backorders';
            InitValue = true;
        }
        field(40; "Auto Release Enabled"; Boolean)
        {
            Caption = 'Auto Release Enabled';
            InitValue = true;
        }
        field(50; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(60; "Website Location Code"; Code[10])
        {
            Caption = 'Website Location Code';
            TableRelation = Location;
        }
        field(70; "Pending Order Timeout (Min.)"; Integer)
        {
            Caption = 'Pending Order Timeout (Min.)';
            InitValue = 60;
            MinValue = 1;
            MaxValue = 10080;
        }
        field(80; "Cleanup Batch Size"; Integer)
        {
            Caption = 'Cleanup Batch Size';
            InitValue = 500;
            MinValue = 1;
            MaxValue = 5000;
        }
        field(90; "Telemetry Enabled"; Boolean)
        {
            Caption = 'Telemetry Enabled';
            InitValue = true;
        }
        field(100; "Schema Version"; Code[20])
        {
            Caption = 'Schema Version';
            InitValue = '2.0.0';
        }
        field(110; "Last Bucket Rebuild"; DateTime)
        {
            Caption = 'Last Bucket Rebuild';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup(): Record "BCSR Setup"
    var
        Setup: Record "BCSR Setup";
    begin
        if not Setup.Get() then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup."Reservation Duration (Min.)" := 15;
            Setup."Pending Order Timeout (Min.)" := 60;
            Setup."Cleanup Batch Size" := 500;
            Setup.Insert(true);
        end;
        exit(Setup);
    end;
}
