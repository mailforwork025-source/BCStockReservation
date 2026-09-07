table 62003 "Bundle Item Option"
{
    Caption = 'Bundle Item Option';
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
            DataClassification = CustomerContent;
        }
        field(3; "Display Order"; Integer)
        {
            Caption = 'Display Order';
            DataClassification = CustomerContent;
        }
        field(4; "Display Style"; Option)
        {
            Caption = 'Display Style';
            OptionMembers = Tile,Capsule;
            OptionCaption = 'Tile,Capsule';
            InitValue = Capsule;
            DataClassification = CustomerContent;
        }
        field(5; "Affects Image"; Boolean)
        {
            Caption = 'Affects Image';
            DataClassification = CustomerContent;
        }
        field(6; "Quantity"; Decimal)
        {
            // How many units of whichever product is selected in this group
            // are consumed per bundle unit ordered (e.g. 4 for a set of table
            // legs). Moved here from Bundle Item Product - all products
            // within one group are the same physical slot, so the quantity
            // is a property of the group, not of any individual product
            // choice within it.
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            InitValue = 1;
        }
        field(7; "Hidden From Customer"; Boolean)
        {
            // Marks this whole group as a mandatory, non-selectable
            // component - e.g. a support/beam that's always part of the
            // base item, never something the customer chooses. The
            // WooCommerce plugin never renders this group's dropdown/pills
            // at all, and GetBundleAvailability/ReserveBundle always
            // include its product in the reservation regardless of what
            // the customer's selection actually contains - so the item's
            // stock is committed on every order even though nobody ever
            // saw a choice for it. A hidden group is expected to have
            // exactly one real Bundle Item Product row (or exactly one
            // marked "Is Default", if it has more); with none, BC logs a
            // real error rather than silently skipping the commitment.
            Caption = 'Hidden From Customer';
            DataClassification = CustomerContent;
        }
        field(8; "Reserves Stock"; Boolean)
        {
            // Whether this group's selection is actually committed against
            // inventory by GetBundleAvailability/ReserveBundle. Defaults to
            // true so every existing group keeps reserving exactly as before
            // this field was introduced. Set to false for a group that is
            // purely a visual/finish selector (e.g. driving the main-photo
            // swap) whose real stock is reserved through a different group
            // instead - otherwise the same physical item could be reserved
            // twice for one order.
            Caption = 'Reserves Stock';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Option Title")
        {
            Clustered = true;
        }
    }
}
