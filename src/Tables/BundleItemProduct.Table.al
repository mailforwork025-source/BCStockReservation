table 62004 "Bundle Item Product"
{
    Caption = 'Bundle Item Product';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
            DataClassification = CustomerContent;
        }
        field(2; "Option Title"; Text[50])
        {
            Caption = 'Option Title';
            TableRelation = "Bundle Item Option"."Option Title" WHERE("Bundle Code" = FIELD("Bundle Code"));
            DataClassification = CustomerContent;
        }
        field(3; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Product";
            OptionCaption = 'Product';
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(5; "Price"; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }
        field(6; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description WHERE("No." = FIELD("Item No.")));
        }
        field(7; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
        }
        field(8; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            InitValue = 1;
        }
        field(9; "Color Hex Code"; Text[10])
        {
            // Swatch color for this option on the WooCommerce bundle UI (e.g.
            // "#RRGGBB"), only meaningful for color-type components ("Color",
            // "Frame Color", etc.) - left blank for non-color options, which
            // the plugin renders as plain text pills instead of swatches.
            Caption = 'Color Hex Code';
            DataClassification = CustomerContent;
        }
        field(10; "Display Label"; Text[50])
        {
            // Short text shown on the pill/swatch instead of "Item
            // Description" - optional, blank falls back to that existing
            // behavior.
            Caption = 'Display Label';
            DataClassification = CustomerContent;
        }
        field(11; "Image URL"; Text[250])
        {
            // Swaps the main product photo when this option is selected on
            // the WooCommerce bundle UI - optional, blank means no swap.
            Caption = 'Image URL';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Option Title", "Item No.")
        {
            Clustered = true;
        }
    }
}
