table 52002 "Bundle Option"
{
    DataClassification = CustomerContent;
    Caption = 'Bundle Option';

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
        }
        field(2; "Component Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Component Line No.';
            TableRelation = "Bundle Component"."Line No." where("Bundle Code" = field("Bundle Code"));
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(4; "Default Option"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Default Option';
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Component Line No.", "Item No.")
        {
            Clustered = true;
        }
    }
}
