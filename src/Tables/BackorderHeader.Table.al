table 50107 "BCSR Backorder Header"
{
    Caption = 'BCSR Backorder Header';
    DataClassification = CustomerContent;
    LookupPageId = "BCSR Backorder Header List";
    DrillDownPageId = "BCSR Backorder Card";

    fields
    {
        field(1; "Backorder ID"; Guid) { Caption = 'Backorder ID'; }
        field(10; "Woo Order ID"; BigInteger) { Caption = 'Woo Order ID'; }
        field(20; "Woo Order No."; Text[50]) { Caption = 'Woo Order No.'; }
        field(30; "BC Sales Order System ID"; Guid) { Caption = 'BC Sales Order System ID'; }
        field(40; "BC Sales Order No."; Code[20]) { Caption = 'BC Sales Order No.'; }
        field(50; Status; Enum "BCSR Backorder Status") { Caption = 'Status'; }
        field(60; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
        field(70; "Modified DateTime"; DateTime) { Caption = 'Modified DateTime'; }
        field(80; "Correlation ID"; Text[100]) { Caption = 'Correlation ID'; }
    }

    keys
    {
        key(PK; "Backorder ID") { Clustered = true; }
        key(WooOrder; "Woo Order ID") { Unique = true; }
        key(SalesOrder; "BC Sales Order System ID") { }
        key(Status; Status) { }
        key(CreatedDate; "Created DateTime") { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Backorder ID") then
            "Backorder ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        "Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Modified DateTime" := CurrentDateTime;
    end;
}
