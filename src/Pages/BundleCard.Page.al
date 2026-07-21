page 52011 "Bundle Card"
{
    PageType = Document;
    SourceTable = "Bundle Header";
    Caption = 'Bundle Items';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                }
                field("Allow Back Order"; Rec."Allow Back Order")
                {
                    ApplicationArea = All;
                }
            }
            part("Bundle Option"; "Bundle Item Options Part")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Code");
                Caption = 'Bundle Option';
            }
            part("Bundle Products"; "Bundle Item Products Part")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Code");
                Caption = 'Bundle Products';
            }
            part("Bundle Combinations"; "Bundle Item Combinations Part")
            {
                ApplicationArea = All;
                SubPageLink = "Bundle Code" = field("Code");
                Caption = 'Bundle Combinations';
            }
        }
        area(FactBoxes)
        {
            part("wooCommerce Shops"; "Bundle Shops Factbox")
            {
                ApplicationArea = All;
                // Add SubPageLink if applicable
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateWebChildren)
            {
                ApplicationArea = All;
                Caption = 'Generate Web Children';
                Image = CreateDocument;
                
                trigger OnAction()
                begin
                    // Implementation goes here
                end;
            }
            action(AssignAllShops)
            {
                ApplicationArea = All;
                Caption = 'Assign All Shops';
                Image = CheckList;
                
                trigger OnAction()
                begin
                    // Implementation goes here
                end;
            }
            action(UploadBundleItem)
            {
                ApplicationArea = All;
                Caption = 'Upload Bundle Item';
                Image = Export;
                
                trigger OnAction()
                begin
                    // Implementation goes here
                end;
            }
        }
        area(Promoted)
        {
            actionref(GenerateWebChildren_Promoted; GenerateWebChildren)
            {
            }
            actionref(AssignAllShops_Promoted; AssignAllShops)
            {
            }
            actionref(UploadBundleItem_Promoted; UploadBundleItem)
            {
            }
        }
    }
}
