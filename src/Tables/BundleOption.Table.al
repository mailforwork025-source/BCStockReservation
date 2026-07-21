table 52002 "Bundle Option"
{
    Caption = 'Bundle Option';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
            DataClassification = CustomerContent;
        }
        field(2; "Component Code"; Code[20])
        {
            Caption = 'Component Code';
            TableRelation = "Bundle Component"."Component Code" WHERE ("Bundle Code" = FIELD("Bundle Code"));
            DataClassification = CustomerContent;
        }
        field(3; "Option Code"; Code[20])
        {
            Caption = 'Option Code';
            DataClassification = CustomerContent;
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(6; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            InitValue = 1;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Component Code", "Option Code")
        {
            Clustered = true;
        }
    }
}
