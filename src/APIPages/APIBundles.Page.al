page 52010 "API - Bundles"
{
    PageType = API;
    Caption = 'Bundles';
    APIPublisher = 'bornov';
    APIGroup = 'woocommerce';
    APIVersion = 'v1.0';
    EntityName = 'bundle';
    EntitySetName = 'bundles';
    SourceTable = "Bundle Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(code; Rec."Bundle Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec."Description")
                {
                    Caption = 'Description';
                }
                field(status; Rec."Status")
                {
                    Caption = 'Status';
                }
                field(basePrice; Rec."Base Price")
                {
                    Caption = 'Base Price';
                }
            }
        }
    }
}
