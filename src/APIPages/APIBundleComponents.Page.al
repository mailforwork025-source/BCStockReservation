page 52011 "API - Bundle Components"
{
    PageType = API;
    Caption = 'Bundle Components';
    APIPublisher = 'bornov';
    APIGroup = 'woocommerce';
    APIVersion = 'v1.0';
    EntityName = 'bundleComponent';
    EntitySetName = 'bundleComponents';
    SourceTable = "Bundle Component";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(bundleCode; Rec."Bundle Code")
                {
                    Caption = 'Bundle Code';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(componentGroupName; Rec."Component Group Name")
                {
                    Caption = 'Component Group Name';
                }
                field(quantityRequired; Rec."Quantity Required")
                {
                    Caption = 'Quantity Required';
                }
                field(isRequired; Rec."Is Required")
                {
                    Caption = 'Is Required';
                }
                field(displayOrder; Rec."Display Order")
                {
                    Caption = 'Display Order';
                }
            }
        }
    }
}
