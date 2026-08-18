table 62022 "Bundle Image Mapping Header"
{
    // One row per exact-match image mapping rule for a bundle: when every
    // condition line under this Serial No. matches the customer's current
    // selection (and ONLY those "Affects Image" = true components -
    // evaluated client-side, see the WooCommerce plugin JS), Image URL
    // replaces the main product image. Distinct from Bundle Combination
    // Header - that table blocks an option combination and optionally
    // shows an image as a side effect; this table exists purely to drive
    // the main image and never blocks anything.
    Caption = 'Bundle Image Mapping Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Bundle Code"; Code[20])
        {
            Caption = 'Bundle Code';
            TableRelation = "Bundle Header";
            DataClassification = CustomerContent;
        }
        field(2; "Serial No."; Integer)
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(3; "Image URL"; Text[250])
        {
            Caption = 'Image URL';
            DataClassification = CustomerContent;
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Bundle Code", "Serial No.")
        {
            Clustered = true;
        }
    }
}
