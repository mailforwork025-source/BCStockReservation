codeunit 50104 "BCSR API Actions"
{
    InherentPermissions = X;
    [ServiceEnabled]
    procedure Reserve(idempotencyKey: Text[150]; correlationId: Text[100]; wooSessionId: Text[100]; wooCustomerId: Text[100]; wooCartHash: Text[100]; wooCartItemKey: Text[100]; itemNo: Code[20]; variantCode: Code[10]; locationCode: Code[10]; uomCode: Code[10]; quantity: Decimal): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        TelemetryMgt: Codeunit "BCSR Telemetry Mgt.";
        ResponsePayload: Text;
    begin
        ReservationService.Reserve(idempotencyKey, correlationId, wooSessionId, wooCustomerId, wooCartHash, wooCartItemKey, itemNo, variantCode, locationCode, uomCode, quantity, ResponsePayload);
        TelemetryMgt.LogEvent('BCSR0001', 'Reserve action completed.', correlationId);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure Release(idempotencyKey: Text[150]; correlationId: Text[100]; reservationId: Guid; reason: Text[100]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        TelemetryMgt: Codeunit "BCSR Telemetry Mgt.";
        ResponsePayload: Text;
    begin
        ReservationService.Release(idempotencyKey, correlationId, reservationId, reason, ResponsePayload);
        TelemetryMgt.LogEvent('BCSR0002', 'Release action completed.', correlationId);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure ReleaseLine(idempotencyKey: Text[150]; correlationId: Text[100]; reservationId: Guid; wooCartItemKey: Text[100]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        TelemetryMgt: Codeunit "BCSR Telemetry Mgt.";
        ResponsePayload: Text;
    begin
        ReservationService.ReleaseLine(idempotencyKey, correlationId, reservationId, wooCartItemKey, ResponsePayload);
        TelemetryMgt.LogEvent('BCSR0007', 'ReleaseLine action completed.', correlationId);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure ConvertToPendingOrder(idempotencyKey: Text[150]; correlationId: Text[100]; reservationId: Guid; wooOrderId: BigInteger; wooOrderNo: Text[50]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        TelemetryMgt: Codeunit "BCSR Telemetry Mgt.";
        ResponsePayload: Text;
    begin
        ReservationService.ConvertToPendingOrder(idempotencyKey, correlationId, reservationId, wooOrderId, wooOrderNo, ResponsePayload);
        TelemetryMgt.LogEvent('BCSR0003', 'Convert to pending order action completed.', correlationId);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure ConfirmSync(idempotencyKey: Text[150]; correlationId: Text[100]; reservationId: Guid; wooOrderId: BigInteger; bcSalesOrderSystemId: Guid; bcSalesOrderNo: Code[20]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        TelemetryMgt: Codeunit "BCSR Telemetry Mgt.";
        ResponsePayload: Text;
    begin
        ReservationService.ConfirmSync(idempotencyKey, correlationId, reservationId, wooOrderId, bcSalesOrderSystemId, bcSalesOrderNo, ResponsePayload);
        TelemetryMgt.LogEvent('BCSR0004', 'Confirm sync action completed.', correlationId);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure MarkManualReview(idempotencyKey: Text[150]; correlationId: Text[100]; reservationId: Guid; reason: Text[250]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        ResponsePayload: Text;
    begin
        ReservationService.MarkManualReview(idempotencyKey, correlationId, reservationId, reason, ResponsePayload);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure CreateOrUpdateBackorder(idempotencyKey: Text[150]; correlationId: Text[100]; wooOrderId: BigInteger; wooOrderNo: Text[50]; wooOrderLineId: BigInteger; bcSalesOrderSystemId: Guid; bcSalesOrderNo: Code[20]; bcSalesLineSystemId: Guid; itemNo: Code[20]; variantCode: Code[10]; locationCode: Code[10]; uomCode: Code[10]; quantity: Decimal): Text
    var
        BackorderService: Codeunit "BCSR Backorder Service";
        ResponsePayload: Text;
    begin
        BackorderService.CreateOrUpdateBackorder(idempotencyKey, correlationId, wooOrderId, wooOrderNo, wooOrderLineId, bcSalesOrderSystemId, bcSalesOrderNo, bcSalesLineSystemId, itemNo, variantCode, locationCode, uomCode, quantity, ResponsePayload);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure GetAvailability(itemNo: Code[20]; variantCode: Code[10]; locationCode: Code[10]; uomCode: Code[10]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        ResponsePayload: Text;
    begin
        ReservationService.GetAvailability(itemNo, variantCode, locationCode, uomCode, ResponsePayload);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure GetBundleAvailability(bundleCode: Code[20]; optionsJson: Text; locationCode: Code[10]; quantity: Decimal): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        ResponsePayload: Text;
    begin
        ReservationService.GetBundleAvailability(bundleCode, optionsJson, locationCode, quantity, ResponsePayload);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure ReserveBundle(idempotencyKey: Text[150]; correlationId: Text[100]; wooSessionId: Text[100]; wooCustomerId: Text[100]; wooCartHash: Text[100]; wooCartItemKey: Text[100]; bundleCode: Code[20]; optionsJson: Text; locationCode: Code[10]; quantity: Decimal): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        TelemetryMgt: Codeunit "BCSR Telemetry Mgt.";
        ResponsePayload: Text;
    begin
        ReservationService.ReserveBundle(idempotencyKey, correlationId, wooSessionId, wooCustomerId, wooCartHash, wooCartItemKey, bundleCode, optionsJson, locationCode, quantity, ResponsePayload);
        TelemetryMgt.LogEvent('BCSR0008', 'ReserveBundle action completed.', correlationId);
        exit(ResponsePayload);
    end;


    // Permanent feature (not diagnostic/test scaffolding): the existing WooCommerce order-sync
    // integration only sends the BC Sales Order Number back to the plugin, not its System ID.
    // The plugin calls this endpoint to resolve the System ID it needs to pass into ConfirmSync.
    [ServiceEnabled]
    procedure GetSalesOrderSystemId(bcSalesOrderNo: Code[20]): Text
    var
        ReservationService: Codeunit "BCSR Reservation Service";
        ResponsePayload: Text;
    begin
        ReservationService.GetSalesOrderSystemId(bcSalesOrderNo, ResponsePayload);
        exit(ResponsePayload);
    end;

    [ServiceEnabled]
    procedure Ping(): Text
    begin
        exit('PONG FROM 50104');
    end;
}
