table 52001 "Bundle Component"
{
    DataClassification = CustomerContent;
    Caption = 'Bundle Component';

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Component Group Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Component Group Name';
        }
        field(4; "Quantity Required"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity Required';
            DecimalPlaces = 0:5;
            InitValue = 1;
        }
        field(5; "Is Required"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Required';
            InitValue = true;
        }
        field(6; "Display Order"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Display Order';
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Line No.")
        {
            Clustered = true;
        }
    }
}
