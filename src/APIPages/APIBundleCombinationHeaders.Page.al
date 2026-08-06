page 62019 APIBundleCombinationHeaders
{
    PageType = API;
    Caption = 'Bundle Combination Headers';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v1.0';
    EntityName = 'bundleCombinationHeader';
    EntitySetName = 'bundleCombinationHeaders';
    SourceTable = "Bundle Combination Header";
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
                field(disabledComponent; Rec."Disabled Component")
                {
                    Caption = 'Disabled Component';
                }
                field(disabledOption; Rec."Disabled Option")
                {
                    Caption = 'Disabled Option';
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
