codeunit 50107 "BCSR Idempotency Mgt."
{
    procedure StartOperation(IdempotencyKey: Text[150]; OperationType: Text[30]; RequestHash: Text[250]; RequestPayload: Text; CorrelationId: Text[100]): Guid
    var
        OperationLog: Record "BCSR Operation Log";
    begin
        if IdempotencyKey = '' then
            Error(IdempotencyRequiredErr);

        OperationLog.Init();
        OperationLog."Idempotency Key" := IdempotencyKey;
        OperationLog."Operation Type" := OperationType;
        OperationLog."Request Hash" := RequestHash;
        OperationLog."Request Payload" := CopyStr(RequestPayload, 1, MaxStrLen(OperationLog."Request Payload"));
        OperationLog.Status := OperationLog.Status::Pending;
        OperationLog."Correlation ID" := CorrelationId;
        OperationLog.Insert(true);
        exit(OperationLog."Operation ID");
    end;

    procedure TryReplay(IdempotencyKey: Text[150]; RequestHash: Text[250]; var ResponsePayload: Text): Boolean
    var
        OperationLog: Record "BCSR Operation Log";
    begin
        if IdempotencyKey = '' then
            exit(false);

        OperationLog.SetRange("Idempotency Key", IdempotencyKey);
        if not OperationLog.FindFirst() then
            exit(false);

        if OperationLog."Request Hash" <> RequestHash then begin
            ResponsePayload := '{"success":false,"errorCode":"IDEMPOTENCY_CONFLICT","message":"Idempotency key was reused with a different payload."}';
            exit(true);
        end;

        ResponsePayload := OperationLog."Response Payload";
        if ResponsePayload = '' then
            ResponsePayload := '{"success":false,"errorCode":"OPERATION_PENDING","message":"Matching operation is still pending."}';
        exit(true);
    end;

    procedure CompleteOperation(OperationId: Guid; RelatedReservationId: Guid; ResponsePayload: Text; HttpStatus: Integer)
    var
        OperationLog: Record "BCSR Operation Log";
    begin
        if not OperationLog.Get(OperationId) then
            exit;
        OperationLog."Response Payload" := CopyStr(ResponsePayload, 1, MaxStrLen(OperationLog."Response Payload"));
        OperationLog.Status := OperationLog.Status::Completed;
        OperationLog."HTTP Status" := HttpStatus;
        OperationLog."Related Reservation ID" := RelatedReservationId;
        OperationLog."Completed DateTime" := CurrentDateTime;
        OperationLog.Modify(true);
    end;

    procedure FailOperation(OperationId: Guid; ErrorCode: Text[50]; ErrorMessage: Text[250]; ResponsePayload: Text; HttpStatus: Integer)
    var
        OperationLog: Record "BCSR Operation Log";
    begin
        if not OperationLog.Get(OperationId) then
            exit;
        OperationLog."Response Payload" := CopyStr(ResponsePayload, 1, MaxStrLen(OperationLog."Response Payload"));
        OperationLog.Status := OperationLog.Status::Failed;
        OperationLog."HTTP Status" := HttpStatus;
        OperationLog."Error Code" := ErrorCode;
        OperationLog."Error Message" := ErrorMessage;
        OperationLog."Completed DateTime" := CurrentDateTime;
        OperationLog.Modify(true);
    end;

    procedure CalculateRequestHash(RequestPayload: Text): Text[250]
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithm: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        exit(CopyStr(CryptographyManagement.GenerateHash(RequestPayload, HashAlgorithm::SHA256), 1, 250));
    end;

    var
        IdempotencyRequiredErr: Label 'Idempotency key is required.';
}
