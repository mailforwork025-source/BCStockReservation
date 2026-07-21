table 52000 "Bundle Header"
{
    Caption = 'Bundle Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(4; "Allow Back Order"; Option)
        {
            Caption = 'Allow Back Order';
            OptionMembers = "Do not allow","Allow";
            OptionCaption = 'Do not allow,Allow';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
