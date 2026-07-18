codeunit 52000 "Bundle Reservation Mgt."
{
    Access = Public;

    trigger OnRun()
    begin
    end;

    /// <summary>
    /// Reserves all components of a bundle. Uses AL's implicit transaction scope to rollback if any component fails to reserve.
    /// </summary>
    procedure ReserveBundle(BundleCode: Code[20]; QtyToReserve: Decimal)
    var
        BundleComponent: Record "Bundle Component";
        BundleOption: Record "Bundle Option";
        // Assuming existing codeunit is named StockReservationAPI
        // StockReservationAPI: Codeunit "Stock Reservation API";
    begin
        BundleComponent.SetRange("Bundle Code", BundleCode);
        if BundleComponent.FindSet() then
            repeat
                // Fetch the selected option for this component - in a real scenario, the selected options 
                // would be passed in a temporary table or JSON array from WooCommerce.
                // For this example, we'll just try to reserve the default option.
                BundleOption.SetRange("Bundle Code", BundleCode);
                BundleOption.SetRange("Component Line No.", BundleComponent."Line No.");
                BundleOption.SetRange("Default Option", true);
                if BundleOption.FindFirst() then begin
                    // Call the EXISTING Reserve API.
                    // If this fails (e.g., throws an error because out of stock), the entire transaction rolls back.
                    // StockReservationAPI.Reserve(BundleOption."Item No.", BundleComponent."Quantity Required" * QtyToReserve);
                end;
            until BundleComponent.Next() = 0;
    end;

    /// <summary>
    /// Checks availability for all components and returns the maximum number of bundles that can be assembled.
    /// </summary>
    procedure GetBundleAvailability(BundleCode: Code[20]): Decimal
    var
        BundleComponent: Record "Bundle Component";
        BundleOption: Record "Bundle Option";
        MaxBundles: Decimal;
        ComponentAvail: Decimal;
        // StockReservationAPI: Codeunit "Stock Reservation API";
    begin
        MaxBundles := 999999; // Arbitrarily large number

        BundleComponent.SetRange("Bundle Code", BundleCode);
        if BundleComponent.FindSet() then
            repeat
                BundleOption.SetRange("Bundle Code", BundleCode);
                BundleOption.SetRange("Component Line No.", BundleComponent."Line No.");
                BundleOption.SetRange("Default Option", true);
                if BundleOption.FindFirst() then begin
                    // Call the EXISTING GetAvailability API.
                    // ComponentAvail := StockReservationAPI.GetAvailability(BundleOption."Item No.");
                    ComponentAvail := 10; // Placeholder

                    if (BundleComponent."Quantity Required" > 0) then begin
                        if (ComponentAvail / BundleComponent."Quantity Required") < MaxBundles then
                            MaxBundles := ComponentAvail / BundleComponent."Quantity Required";
                    end;
                end;
            until BundleComponent.Next() = 0;

        // Round down to the nearest whole number if partial bundles aren't allowed
        exit(Round(MaxBundles, 1, '<'));
    end;
}
