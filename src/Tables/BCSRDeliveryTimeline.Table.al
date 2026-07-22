table 52030 "BCSR Delivery Timeline"
{
    DataClassification = CustomerContent;
    Caption = 'Delivery Timeline Rule';
    LookupPageId = "BCSR Delivery Timelines";
    DrillDownPageId = "BCSR Delivery Timelines";

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(2; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";
        }
        field(3; "Quantity From"; Decimal)
        {
            Caption = 'Quantity From';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(4; "Quantity To"; Decimal)
        {
            Caption = 'Quantity To';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(5; "Delivery Days"; Integer)
        {
            Caption = 'Delivery Days';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(6; "Priority"; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(7; "Active"; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(8; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
        field(9; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Item No.", "Item Category Code", "Quantity From")
        {
            Clustered = true;
        }
        key(ActiveDates; Active, "Effective Date", "Expiry Date")
        {
        }
    }
}
