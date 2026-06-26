table 50108 "BCSR Backorder Line"
{
    Caption = 'BCSR Backorder Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Backorder Line ID"; Guid) { Caption = 'Backorder Line ID'; }
        field(10; "Backorder ID"; Guid) { Caption = 'Backorder ID'; TableRelation = "BCSR Backorder Header"; }
        field(20; "Line No."; Integer) { Caption = 'Line No.'; }
        field(30; "Woo Order ID"; BigInteger) { Caption = 'Woo Order ID'; }
        field(40; "Woo Order Line ID"; BigInteger) { Caption = 'Woo Order Line ID'; }
        field(50; "BC Sales Line System ID"; Guid) { Caption = 'BC Sales Line System ID'; }
        field(60; "Item No."; Code[20]) { Caption = 'Item No.'; TableRelation = Item; }
        field(70; "Variant Code"; Code[10]) { Caption = 'Variant Code'; TableRelation = "Item Variant".Code where("Item No." = field("Item No.")); }
        field(80; "Location Code"; Code[10]) { Caption = 'Location Code'; TableRelation = Location; }
        field(90; "Unit of Measure Code"; Code[10]) { Caption = 'Unit of Measure Code'; TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No.")); }
        field(100; Quantity; Decimal) { Caption = 'Quantity'; DecimalPlaces = 0 : 5; }
        field(110; "Quantity (Base)"; Decimal) { Caption = 'Quantity (Base)'; DecimalPlaces = 0 : 5; }
        field(120; "Allocated Qty. (Base)"; Decimal) { Caption = 'Allocated Qty. (Base)'; DecimalPlaces = 0 : 5; }
        field(130; "Fulfilled Qty. (Base)"; Decimal) { Caption = 'Fulfilled Qty. (Base)'; DecimalPlaces = 0 : 5; }
        field(140; Status; Enum "BCSR Backorder Status") { Caption = 'Status'; }
        field(150; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
        field(160; "Modified DateTime"; DateTime) { Caption = 'Modified DateTime'; }
        field(170; "Correlation ID"; Text[100]) { Caption = 'Correlation ID'; }
    }

    keys
    {
        key(PK; "Backorder Line ID") { Clustered = true; }
        key(BackorderLine; "Backorder ID", "Line No.") { }
        key(WooLine; "Woo Order ID", "Woo Order Line ID") { Unique = true; }
        key(SalesLine; "BC Sales Line System ID") { }
        key(ItemStatus; "Item No.", "Variant Code", "Location Code", Status) { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Backorder Line ID") then
            "Backorder Line ID" := CreateGuid();
        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;
        "Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Modified DateTime" := CurrentDateTime;
    end;
}
