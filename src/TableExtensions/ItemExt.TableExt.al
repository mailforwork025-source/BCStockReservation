tableextension 50121 "BCSR Item Ext." extends Item
{
    fields
    {
        field(51003; "BCSR Enable Reservation"; Boolean)
        {
            Caption = 'Enable Stock Reservation';
            DataClassification = CustomerContent;
        }
        field(51004; "BCSR Enable Backorder"; Boolean)
        {
            Caption = 'Enable Backorder';
            DataClassification = CustomerContent;
        }
    }
}
