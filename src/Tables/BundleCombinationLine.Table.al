table 62008 "Bundle Combination Line"
{
    Caption = 'Bundle Combination Line';
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
            TableRelation = "Bundle Combination Header"."Serial No." WHERE("Bundle Code" = FIELD("Bundle Code"));
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Component"; Text[50])
        {
            Caption = 'Component';
            TableRelation = "Bundle Item Option"."Option Title" WHERE("Bundle Code" = FIELD("Bundle Code"));
            DataClassification = CustomerContent;
        }
        field(5; "Option"; Code[20])
        {
            Caption = 'Option';
            TableRelation = "Bundle Item Product"."Item No." WHERE("Bundle Code" = FIELD("Bundle Code"), "Option Title" = FIELD("Component"));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Serial No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
