pageextension 51003 "BCSR Biz Mgr RC Ext." extends "Business Manager Role Center"
{
    layout
    {
        addfirst(RoleCenter)
        {
            part(BCSRBackorderActivities; "BCSR Backorder Activities")
            {
                ApplicationArea = All;
            }
        }
    }
}
