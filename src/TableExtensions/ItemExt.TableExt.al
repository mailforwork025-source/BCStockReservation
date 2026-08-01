tableextension 60121 "BCSR Item Ext." extends Item
{
    fields
    {
        field(61003; "BCSR Enable Reservation"; Boolean)
        {
            Caption = 'Enable Stock Reservation';
            DataClassification = CustomerContent;
        }
        field(61004; "BCSR Enable Backorder"; Boolean)
        {
            Caption = 'Enable Backorder';
            DataClassification = CustomerContent;
        }
    }
}
