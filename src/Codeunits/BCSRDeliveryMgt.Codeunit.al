codeunit 52030 "BCSR Delivery Mgt."
{
    procedure CalculateDeliveryTimeline(ItemNo: Code[20]; Quantity: Decimal; var DeliveryDays: Integer; var EstimatedDate: Date): Boolean
    var
        Item: Record Item;
        DeliveryRule: Record "BCSR Delivery Timeline";
        FoundRule: Boolean;
    begin
        FoundRule := false;
        DeliveryDays := GetDefaultDeliveryDays(); // Fallback default
        EstimatedDate := CalcDate(StrSubstNo('<%1D>', DeliveryDays), Today);

        if ItemNo = '' then
            exit(true);

        if not Item.Get(ItemNo) then
            exit(false);

        // 1. Check Item-specific rules
        DeliveryRule.Reset();
        DeliveryRule.SetRange(Active, true);
        DeliveryRule.SetRange("Item No.", ItemNo);
        DeliveryRule.SetFilter("Quantity From", '<=%1', Quantity);
        // Quantity To is either 0 (unlimited) or >= Quantity
        DeliveryRule.SetFilter("Quantity To", '0|>=%1', Quantity);
        
        // Filter by Date
        DeliveryRule.SetFilter("Effective Date", '%1|<=%2', 0D, Today);
        DeliveryRule.SetFilter("Expiry Date", '%1|>=%2', 0D, Today);
        
        DeliveryRule.SetCurrentKey("Priority"); // We would ideally have Priority sorting, but fallback to looping if needed

        if DeliveryRule.FindSet() then begin
            // For simplicity, take the first valid rule found (assuming they are set up correctly, or you can implement a priority sort)
            FoundRule := true;
        end else begin
            // 2. Check Category-specific rules
            if Item."Item Category Code" <> '' then begin
                DeliveryRule.Reset();
                DeliveryRule.SetRange(Active, true);
                DeliveryRule.SetRange("Item No.", '');
                DeliveryRule.SetRange("Item Category Code", Item."Item Category Code");
                DeliveryRule.SetFilter("Quantity From", '<=%1', Quantity);
                DeliveryRule.SetFilter("Quantity To", '0|>=%1', Quantity);
                DeliveryRule.SetFilter("Effective Date", '%1|<=%2', 0D, Today);
                DeliveryRule.SetFilter("Expiry Date", '%1|>=%2', 0D, Today);
                
                if DeliveryRule.FindSet() then
                    FoundRule := true;
            end;
        end;

        // 3. Check Default Rules (Blank Item, Blank Category)
        if not FoundRule then begin
            DeliveryRule.Reset();
            DeliveryRule.SetRange(Active, true);
            DeliveryRule.SetRange("Item No.", '');
            DeliveryRule.SetRange("Item Category Code", '');
            DeliveryRule.SetFilter("Quantity From", '<=%1', Quantity);
            DeliveryRule.SetFilter("Quantity To", '0|>=%1', Quantity);
            DeliveryRule.SetFilter("Effective Date", '%1|<=%2', 0D, Today);
            DeliveryRule.SetFilter("Expiry Date", '%1|>=%2', 0D, Today);
            
            if DeliveryRule.FindSet() then
                FoundRule := true;
        end;

        if FoundRule then begin
            DeliveryDays := DeliveryRule."Delivery Days";
            EstimatedDate := CalcDate(StrSubstNo('<%1D>', DeliveryDays), Today);
        end;

        exit(true);
    end;

    procedure CalculateBundleDeliveryTimeline(BundleCode: Code[20]; OptionsJson: Text; Quantity: Decimal; var DeliveryDays: Integer; var EstimatedDate: Date): Boolean
    var
        JArray: JsonArray;
        JToken: JsonToken;
        JObject: JsonObject;
        ComponentCodeToken: JsonToken;
        OptionCodeToken: JsonToken;
        BundleProduct: Record "Bundle Item Product";
        MaxDeliveryDays: Integer;
        CompDeliveryDays: Integer;
        CompEstimatedDate: Date;
    begin
        if not JArray.ReadFrom(OptionsJson) then
            exit(false);

        MaxDeliveryDays := 0;

        foreach JToken in JArray do begin
            JObject := JToken.AsObject();
            JObject.Get('optionTitle', ComponentCodeToken);
            JObject.Get('itemNo', OptionCodeToken);

            if BundleProduct.Get(BundleCode, ComponentCodeToken.AsValue().AsText(), OptionCodeToken.AsValue().AsCode()) then begin
                if CalculateDeliveryTimeline(BundleProduct."Item No.", Quantity, CompDeliveryDays, CompEstimatedDate) then begin
                    if CompDeliveryDays > MaxDeliveryDays then
                        MaxDeliveryDays := CompDeliveryDays;
                end;
            end;
        end;

        DeliveryDays := MaxDeliveryDays;
        if DeliveryDays = 0 then
            DeliveryDays := GetDefaultDeliveryDays();
            
        EstimatedDate := CalcDate(StrSubstNo('<%1D>', DeliveryDays), Today);
        exit(true);
    end;

    local procedure GetDefaultDeliveryDays(): Integer
    begin
        exit(3); // Default 3 days if no rules exist at all
    end;
}
