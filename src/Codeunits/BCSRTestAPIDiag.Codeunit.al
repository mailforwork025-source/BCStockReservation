codeunit 50199 "BCSR Test API Diag"
{
    
    [ServiceEnabled]
    
    procedure Ping(): Text
    begin
        Message(
            'UserId=%1\CurrentCompany=%2',
            UserId(),
            CompanyName());

        exit('PONG');
    end;
}