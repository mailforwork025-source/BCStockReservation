codeunit 50199 "BCSR Test API Diag"
{
    [ServiceEnabled]
    procedure Ping(): Text
    begin
        exit('PONG');
    end;
}
