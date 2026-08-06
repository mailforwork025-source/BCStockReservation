page 62018 "Bundle Combination Lines Part"
{
    PageType = ListPart;
    SourceTable = "Bundle Combination Line";
    Caption = 'Conditions';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Component"; Rec."Component")
                {
                    ApplicationArea = All;
                }
                field("Option"; Rec."Option")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        Line: Record "Bundle Combination Line";
    begin
        Line.SetRange("Bundle Code", Rec."Bundle Code");
        Line.SetRange("Serial No.", Rec."Serial No.");
        if Line.FindLast() then
            exit(Line."Line No." + 1);
        exit(1);
    end;
}
