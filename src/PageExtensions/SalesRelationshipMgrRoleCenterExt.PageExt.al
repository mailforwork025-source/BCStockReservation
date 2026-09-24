pageextension 61004 "BCSR Sales Rel. Mgr RC Ext." extends "Sales & Relationship Mgr. RC"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(BCSRBackorderActivities; "BCSR Backorder Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(sections)
        {
            group(BCSRMenuGroup)
            {
                Caption = 'BC Stock Reservation';

                action(BCSRSetupAction)
                {
                    ApplicationArea = All;
                    Caption = 'Stock Reservation Setup';
                    RunObject = Page "Stock Reservation Setup";
                    ToolTip = 'Configure reservation duration, warning thresholds, and enable/disable reservations, backorders, and bundles.';
                }
                action(BCSRActiveReservationsAction)
                {
                    ApplicationArea = All;
                    Caption = 'Active Reservations';
                    RunObject = Page "Active Reservations";
                    ToolTip = 'View currently held stock reservations from WooCommerce carts and checkouts.';
                }
                action(BCSRReservationHistoryAction)
                {
                    ApplicationArea = All;
                    Caption = 'Reservation History';
                    RunObject = Page "Reservation History";
                    ToolTip = 'View past reservations, including expired, released, and confirmed ones.';
                }
                action(BCSRBackorderListAction)
                {
                    ApplicationArea = All;
                    Caption = 'Backorder List';
                    RunObject = Page "Backorder List";
                    ToolTip = 'View and manage backorders waiting to be fulfilled.';
                }
                action(BCSRBundleListAction)
                {
                    ApplicationArea = All;
                    Caption = 'Bundle List';
                    RunObject = Page "Bundle List";
                    ToolTip = 'View and manage bundle products, combinations, and image mappings.';
                }
                action(BCSRAvailabilityDashboardAction)
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Avail. Dashboard';
                    RunObject = Page "Inventory Avail. Dashboard";
                    ToolTip = 'View real-time inventory availability across items and locations.';
                }
            }
        }
    }
}
