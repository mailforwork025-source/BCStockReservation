codeunit 50108 "BCSR Audit Mgt."
{
    procedure LogReservation(ReservationId: Guid; EventType: Text[50]; FromStatus: Text[30]; ToStatus: Text[30]; Message: Text[250]; OperationId: Guid; CorrelationId: Text[100])
    begin
        Log('Reservation', ReservationId, EventType, FromStatus, ToStatus, Message, OperationId, CorrelationId);
    end;

    procedure LogBackorder(BackorderId: Guid; EventType: Text[50]; FromStatus: Text[30]; ToStatus: Text[30]; Message: Text[250]; OperationId: Guid; CorrelationId: Text[100])
    begin
        Log('Backorder', BackorderId, EventType, FromStatus, ToStatus, Message, OperationId, CorrelationId);
    end;

    procedure LogFailure(EntityId: Guid; EventType: Text[50]; Message: Text[250]; OperationId: Guid; CorrelationId: Text[100])
    begin
        Log('Failure', EntityId, EventType, '', '', Message, OperationId, CorrelationId);
    end;

    local procedure Log(EntityType: Text[30]; EntityId: Guid; EventType: Text[50]; FromStatus: Text[30]; ToStatus: Text[30]; Message: Text[250]; OperationId: Guid; CorrelationId: Text[100])
    var
        AuditLog: Record "BCSR Audit Log";
    begin
        AuditLog.Init();
        AuditLog."Entity Type" := EntityType;
        AuditLog."Entity ID" := EntityId;
        AuditLog."Event Type" := EventType;
        AuditLog."From Status" := FromStatus;
        AuditLog."To Status" := ToStatus;
        AuditLog.Message := Message;
        AuditLog."Operation ID" := OperationId;
        AuditLog."Correlation ID" := CorrelationId;
        AuditLog.Insert(true);
    end;
}
