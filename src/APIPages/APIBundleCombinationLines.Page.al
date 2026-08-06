page 62020 APIBundleCombinationLines
{
    PageType = API;
    Caption = 'Bundle Combination Lines';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    APIVersion = 'v1.0';
    EntityName = 'bundleCombinationLine';
    EntitySetName = 'bundleCombinationLines';
    SourceTable = "Bundle Combination Line";
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
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(component; Rec."Component")
                {
                    Caption = 'Component';
                }
                field(option; Rec."Option")
                {
                    Caption = 'Option';
                }
            }
        }
    }
}
