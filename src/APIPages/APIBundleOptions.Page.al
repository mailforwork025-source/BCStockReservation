page 52002 APIBundleOptions
{
    // Exposes the selectable values within each bundle component slot (e.g.
    // "Red" -> item FURN-RED-01) so the WooCommerce plugin can populate each
    // dropdown and, via `price`, compute the bundle price roll-up. Same gap
    // as APIBundleComponents: the plugin already called this bundleOptions
    // OData entity, but nothing exposed "Bundle Item Product" here.
    //
    // "Bundle Item Product".Price is the price of THIS selected option -
    // Bundle Header carries no price field of its own, so bundle pricing is
    // sum-of-selected-component-prices, not a flat bundle price.
    PageType = API;
    Caption = 'Bundle Options';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v1.0';
    EntityName = 'bundleOption';
    EntitySetName = 'bundleOptions';
    SourceTable = "Bundle Item Product";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(bundleCode; Rec."Bundle Code")
                {
                    Caption = 'Bundle Code';
                }
                field(componentCode; Rec."Option Title")
                {
                    Caption = 'Component Code';
                }
                field(optionCode; Rec."Item No.")
                {
                    Caption = 'Option Code';
                }
                field(description; Rec."Item Description")
                {
                    Caption = 'Description';
                }
                field(price; Rec.Price)
                {
                    Caption = 'Price';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
            }
        }
    }
}
