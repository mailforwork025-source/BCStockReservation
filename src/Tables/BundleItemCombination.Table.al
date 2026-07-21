table 52005 "Bundle Item Combination"
{
    Caption = 'Bundle Item Combination';
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
        field(3; "Option 1 Type"; Option)
        {
            Caption = 'Option 1 Type';
            OptionMembers = "Product";
            OptionCaption = 'Product';
            DataClassification = CustomerContent;
        }
        field(4; "Option 1 Title"; Text[50])
        {
            Caption = 'Option 1 Title';
            TableRelation = "Bundle Item Option"."Option Title" WHERE("Bundle Code" = FIELD("Bundle Code"));
            DataClassification = CustomerContent;
        }
        field(5; "Option 1 Value"; Code[20])
        {
            Caption = 'Option 1 Value';
            TableRelation = "Bundle Item Product"."Item No." WHERE("Bundle Code" = FIELD("Bundle Code"), "Option Title" = FIELD("Option 1 Title"));
            DataClassification = CustomerContent;
        }
        field(6; "Option 2 Type"; Option)
        {
            Caption = 'Option 2 Type';
            OptionMembers = "Product";
            OptionCaption = 'Product';
            DataClassification = CustomerContent;
        }
        field(7; "Option 2 Title"; Text[50])
        {
            Caption = 'Option 2 Title';
            TableRelation = "Bundle Item Option"."Option Title" WHERE("Bundle Code" = FIELD("Bundle Code"));
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
