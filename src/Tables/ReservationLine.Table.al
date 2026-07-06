table 50103 "BCSR Reservation Line"
{
    Caption = 'BCSR Reservation Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Reservation Line ID"; Guid)
        {
            Caption = 'Reservation Line ID';
        }
        field(10; "Reservation ID"; Guid)
        {
            Caption = 'Reservation ID';
            TableRelation = "BCSR Reservation Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Woo Cart Item Key"; Text[100])
        {
            Caption = 'Woo Cart Item Key';
        }
        field(40; "Woo Order Line ID"; BigInteger)
        {
            Caption = 'Woo Order Line ID';
        }
        field(50; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(60; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(70; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(100; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(110; "Reserved Qty. (Base)"; Decimal)
        {
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(120; "Backorder Qty. (Base)"; Decimal)
        {
            Caption = 'Backorder Qty. (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(130; "Bucket ID"; Guid)
        {
            Caption = 'Bucket ID';
            TableRelation = "BCSR Availability Bucket";
        }
        field(140; Status; Enum "BCSR Reservation Status")
        {
            Caption = 'Status';
        }
        field(150; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
        }
        field(160; "Modified DateTime"; DateTime)
        {
            Caption = 'Modified DateTime';
        }
        field(170; "Correlation ID"; Text[100])
        {
            Caption = 'Correlation ID';
        }
        field(180; "BC Sales Line System ID"; Guid)
        {
            Caption = 'BC Sales Line System ID';
        }
    }

    keys
    {
        key(PK; "Reservation Line ID")
        {
            Clustered = true;
        }
        key(ReservationLine; "Reservation ID", "Line No.")
        {
        }
        key(ReservationCartItem; "Reservation ID", "Woo Cart Item Key")
        {
            Unique = true;
        }
        key(BucketStatus; "Bucket ID", Status)
        {
        }
        key(ItemStatus; "Item No.", "Variant Code", "Location Code", Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Reservation Line ID") then
            "Reservation Line ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        "Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Modified DateTime" := CurrentDateTime;
    end;
}
