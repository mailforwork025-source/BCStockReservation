table 62005 "Bundle Combination Header"
{
    Caption = 'Bundle Combination Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
            DataClassification = CustomerContent;
        }
        field(2; "Serial No."; Integer)
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(3; "Disabled Component"; Text[50])
        {
            Caption = 'Disabled Component';
            TableRelation = "Bundle Item Option"."Option Title" WHERE("Bundle Code" = FIELD("Bundle Code"));
            DataClassification = CustomerContent;
        }
        field(4; "Disabled Option"; Code[20])
        {
            Caption = 'Disabled Option';
            TableRelation = "Bundle Item Product"."Item No." WHERE("Bundle Code" = FIELD("Bundle Code"), "Option Title" = FIELD("Disabled Component"));
            DataClassification = CustomerContent;
        }
        field(5; "Image URL"; Text[250])
        {
            Caption = 'Image URL';
            DataClassification = CustomerContent;
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Serial No.")
        {
            Clustered = true;
        }
    }
}
