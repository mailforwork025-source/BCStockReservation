table 62003 "Bundle Item Option"
{
    Caption = 'Bundle Item Option';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
            DataClassification = CustomerContent;
        }
        field(2; "Option Title"; Text[50])
        {
            Caption = 'Option Title';
            DataClassification = CustomerContent;
        }
        field(3; "Display Order"; Integer)
        {
            Caption = 'Display Order';
            DataClassification = CustomerContent;
        }
        field(4; "Display Style"; Option)
        {
            Caption = 'Display Style';
            OptionMembers = Tile,Capsule;
            OptionCaption = 'Tile,Capsule';
            InitValue = Capsule;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Option Title")
        {
            Clustered = true;
        }
    }
}
