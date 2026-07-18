tableextension 52000 "Bundle Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(52000; "Bundle Parent Line No."; Integer)
        {
            Caption = 'Bundle Parent Line No.';
            DataClassification = CustomerContent;
            Description = 'Links this component line to its parent bundle line.';
        }
    }
}
