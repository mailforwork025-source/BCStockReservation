table 52000 "Bundle Header"
{
    DataClassification = CustomerContent;
    Caption = 'Bundle Header';
    LookupPageId = "Bundle List";
    DrillDownPageId = "Bundle List";

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bundle Code';
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Status"; Enum "Bundle Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(4; "Base Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Price';
        }
    }

    keys
    {
        key(PK; "Bundle Code")
        {
            Clustered = true;
        }
    }
}
