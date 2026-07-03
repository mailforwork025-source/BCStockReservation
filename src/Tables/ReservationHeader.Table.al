table 50102 "BCSR Reservation Header"
{
    Caption = 'BCSR Reservation Header';
    DataClassification = CustomerContent;
    LookupPageId = "BCSR Reservation Card";
    DrillDownPageId = "BCSR Reservation Card";

    fields
    {
        field(1; "Reservation ID"; Guid)
        {
            Caption = 'Reservation ID';
        }
        field(10; "Woo Session ID"; Text[100])
        {
            Caption = 'Woo Session ID';
        }
        field(20; "Woo Customer ID"; Text[100])
        {
            Caption = 'Woo Customer ID';
        }
        field(30; "Woo Cart Hash"; Text[100])
        {
            Caption = 'Woo Cart Hash';
        }
        field(40; "Woo Order ID"; BigInteger)
        {
            Caption = 'Woo Order ID';
        }
        field(50; "Woo Order No."; Text[50])
        {
            Caption = 'Woo Order No.';
        }
        field(60; "BC Sales Order System ID"; Guid)
        {
            Caption = 'BC Sales Order System ID';
        }
        field(70; "BC Sales Order No."; Code[20])
        {
            Caption = 'BC Sales Order No.';
        }
        field(80; Status; Enum "BCSR Reservation Status")
        {
            Caption = 'Status';
        }
        field(90; "Expires At"; DateTime)
        {
            Caption = 'Expires At';
        }
        field(100; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
        }
        field(110; "Modified DateTime"; DateTime)
        {
            Caption = 'Modified DateTime';
        }
        field(120; "Correlation ID"; Text[100])
        {
            Caption = 'Correlation ID';
        }
        field(130; "Manual Review Reason"; Text[250])
        {
            Caption = 'Manual Review Reason';
        }
        field(140; "Last Operation ID"; Guid)
        {
            Caption = 'Last Operation ID';
        }
    }

    keys
    {
        key(PK; "Reservation ID")
        {
            Clustered = true;
        }
        key(SessionStatus; "Woo Session ID", Status)
        {
        }
        key(StatusExpiry; Status, "Expires At")
        {
        }
        key(WooOrder; "Woo Order ID")
        {
        }
        key(SalesOrder; "BC Sales Order System ID")
        {
        }
        key(CreatedDate; "Created DateTime")
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Reservation ID") then
            "Reservation ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        "Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Modified DateTime" := CurrentDateTime;
    end;
}
