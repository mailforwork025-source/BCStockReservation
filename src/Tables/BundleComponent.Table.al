table 52001 "Bundle Component"
{
    Caption = 'Bundle Component';
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
            DataClassification = CustomerContent;
        }
        field(3; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Required","Optional";
            OptionCaption = 'Required,Optional';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Component Code")
        {
            Clustered = true;
        }
    }
}
