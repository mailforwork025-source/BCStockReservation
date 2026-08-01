codeunit 60111 "BCSR Test API"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    [ServiceEnabled]
    procedure Ping(): Text
    begin
        exit('PONG');
    end;
}
