table 50101 "BCSR Availability Bucket"
{
    Caption = 'BCSR Availability Bucket';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bucket ID"; Guid)
        {
            Caption = 'Bucket ID';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(20; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(40; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(50; "Physical Qty."; Decimal)
        {
            Caption = 'Physical Qty.';
            DecimalPlaces = 0 : 5;
        }
        field(60; "Reserved Qty."; Decimal)
        {
            Caption = 'Reserved Qty.';
            DecimalPlaces = 0 : 5;
        }
        field(70; "Pending Order Qty."; Decimal)
        {
            Caption = 'Pending Order Qty.';
            DecimalPlaces = 0 : 5;
        }
        field(80; "Backorder Qty."; Decimal)
        {
            Caption = 'Backorder Qty.';
            DecimalPlaces = 0 : 5;
        }
        field(85; "Native Reserved Qty."; Decimal)
        {
            Caption = 'Native Reserved Qty. (BC Sales Orders)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(90; "Last Recalculated"; DateTime)
        {
            Caption = 'Last Recalculated';
        }
        field(100; "Last Operation ID"; Guid)
        {
            Caption = 'Last Operation ID';
        }
    }

    keys
    {
        key(PK; "Bucket ID")
        {
            Clustered = true;
        }
        key(BucketKey; "Item No.", "Variant Code", "Location Code")
        {
            Unique = true;
        }
        key(ItemLocation; "Item No.", "Location Code")
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Bucket ID") then
            "Bucket ID" := CreateGuid();
        if "Last Recalculated" = 0DT then
            "Last Recalculated" := CurrentDateTime;
    end;
}
