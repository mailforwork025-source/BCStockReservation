table 62041 "Bundle Item Product V2"
{
    // DEAD TABLE - do not read or write. Introduced 2.5.0 as a Variant
    // Code-keyed replacement for table 62004 (needed a genuinely new
    // object name since BC's schema sync matches tables by name across
    // versions, so reusing "Bundle Item Product" on a new ID still got
    // treated as the same table and rejected the wider key). Abandoned
    // 2.6.0 in favor of every real option getting its own distinct Item
    // No. instead - all data was moved back to 62004 and this table
    // cleared. Stays defined only because BC does not allow removing a
    // previously-published table.
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
            // Part of the primary key as of 2.5.0 - lets one Item No.
            // appear more than once in the same group, one row per real
            // Item Variant (e.g. a "Dimension" group on the bundle's own
            // item, one row per size variant, each with its own Price).
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD("Item No."));
            DataClassification = CustomerContent;
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
        field(12; "Is Default"; Boolean)
        {
            // The option WooCommerce treats as "selected" for this group
            // before the customer has explicitly picked anything, for
            // computing the initial "effective selection" that drives the
            // main image on page load. Only meaningful for a group whose
            // "Bundle Item Option"."Affects Image" = true; data entry is
            // responsible for marking exactly one option per such group -
            // not enforced (multiple/zero defaults don't corrupt anything,
            // WooCommerce just uses whichever default it's given), but
            // flagged here as a soft warning to catch the common mistake
            // early.
            Caption = 'Is Default';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                OtherOption: Record "Bundle Item Product V2";
            begin
                if not "Is Default" then
                    exit;

                OtherOption.SetRange("Bundle Code", "Bundle Code");
                OtherOption.SetRange("Option Title", "Option Title");
                OtherOption.SetRange("Is Default", true);
                OtherOption.SetFilter("Item No.", '<>%1', "Item No.");
                if not OtherOption.IsEmpty() then
                    Message('Another option in "%1" is already marked Is Default. Only one default per group is expected - the WooCommerce plugin uses whichever default it receives, so leaving more than one set is not an error, but is likely unintended.', "Option Title");
            end;
        }
        field(13; "Name"; Text[100])
        {
            // Short, human-readable name for this option, distinct from
            // "Display Label" (customer-facing pill/swatch text). Used to
            // build the auto-generated Description on Bundle Image Mapping
            // Header rows (e.g. "White + Black + Large"), so it should read
            // well when joined with " + " against other options' Names.
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Option Title", "Item No.", "Variant Code")
        {
            Clustered = true;
        }
    }
}
