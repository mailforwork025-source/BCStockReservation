page 62027 APIBundleImageMappingHeaders
{
    PageType = API;
    Caption = 'Bundle Image Mapping Headers';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v1.0';
    EntityName = 'bundleImageMappingHeader';
    EntitySetName = 'bundleImageMappingHeaders';
    SourceTable = "Bundle Image Mapping Header";
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
                field(serialNo; Rec."Serial No.")
                {
                    Caption = 'Serial No.';
                }
                field(imageUrl; Rec."Image URL")
                {
                    Caption = 'Image URL';
                }
                field(description; Rec."Description")
                {
                    Caption = 'Description';
                }
            }
        }
    }
}
