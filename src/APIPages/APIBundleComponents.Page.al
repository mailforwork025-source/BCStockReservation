page 52001 APIBundleComponents
{
    // Exposes the component "slots" of a bundle (e.g. "Color", "Size") so the
    // WooCommerce plugin can render one dropdown per slot. Previously the
    // plugin called this bundleComponents OData entity but no page defined
    // it - every request 404'd and bundle products always showed the
    // "temporarily unavailable" message regardless of BC's actual state.
    //
    // "Bundle Item Option" has no Required/Optional distinction today, so
    // `type` is omitted here rather than hardcoded to a value the data
    // doesn't actually support - the WooCommerce side treats a missing
    // type as "Required" (the safer default: never lets a mandatory
    // selection look skippable). Add a real field here first if the
    // business ever needs true optional components.
    PageType = API;
    Caption = 'Bundle Components';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v1.0';
    EntityName = 'bundleComponent';
    EntitySetName = 'bundleComponents';
    SourceTable = "Bundle Item Option";
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
                field(description; Rec."Option Title")
                {
                    Caption = 'Description';
                }
                field(displayOrder; Rec."Display Order")
                {
                    Caption = 'Display Order';
                }
            }
        }
    }
}
