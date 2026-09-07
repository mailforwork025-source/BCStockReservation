table 62000 "Bundle Header"
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
        field(5; "Default Image URL"; Text[250])
        {
            // Plain fallback for the main product image on the WooCommerce
            // bundle UI - used only when no Bundle Image Mapping row matches
            // even the default-driven effective selection (a data-entry gap
            // safety net, not the normal case: the normal case always
            // resolves to a mapped image via the per-group Is Default
            // options). Never used for the small swatch/tile buttons -
            // those still use each option's own "Bundle Item Product"."Image URL".
            Caption = 'Default Image URL';
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
