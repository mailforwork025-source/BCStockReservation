codeunit 50109 "BCSR Telemetry Mgt."
{
    procedure LogEvent(EventId: Text[50]; Message: Text[250]; CorrelationId: Text[100])
    var
        Setup: Record "BCSR Setup";
        CustomDimensions: Dictionary of [Text, Text];
    begin
        Setup.GetSetup();
        if not Setup."Telemetry Enabled" then
            exit;
        CustomDimensions.Add('CorrelationId', CorrelationId);
        Session.LogMessage(EventId, Message, Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, CustomDimensions);
    end;
}
