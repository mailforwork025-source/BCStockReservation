page 52002 APIBundleOptions
{
    PageType = API;
    Caption = 'Bundle Options';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v1.0';
    EntityName = 'bundleOption';
    EntitySetName = 'bundleOptions';
    SourceTable = "Bundle Option";
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
                field(componentCode; Rec."Component Code")
                {
                    Caption = 'Component Code';
                }
                field(optionCode; Rec."Option Code")
                {
                    Caption = 'Option Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }
}
