page 52033 "BCSR Delivery API"
{
    PageType = API;
    APIVersion = 'v1.0';
    APIPublisher = 'bornov';
    APIGroup = 'stockReservation';
    EntityName = 'deliveryTimeline';
    EntitySetName = 'deliveryTimelines';
    SourceTable = "BCSR Delivery Timeline"; // Dummy source table, as we are mainly using this for actions
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.SystemId) { ApplicationArea = All; }
            }
        }
    }

    [ServiceEnabled]
    procedure CalculateDelivery(ItemNo: Code[20]; Quantity: Decimal; IsBundle: Boolean; OptionsJson: Text; var ResponsePayload: Text)
    var
        DeliveryMgt: Codeunit "BCSR Delivery Mgt.";
        DeliveryDays: Integer;
        EstimatedDate: Date;
        Success: Boolean;
    begin
        if IsBundle then
            Success := DeliveryMgt.CalculateBundleDeliveryTimeline(ItemNo, OptionsJson, Quantity, DeliveryDays, EstimatedDate)
        else
            Success := DeliveryMgt.CalculateDeliveryTimeline(ItemNo, Quantity, DeliveryDays, EstimatedDate);

        if Success then
            ResponsePayload :=
                '{' +
                '"success":true,' +
                '"itemNo":"' + Format(ItemNo) + '",' +
                '"quantity":' + Format(Quantity, 0, 9) + ',' +
                '"deliveryDays":' + Format(DeliveryDays) + ',' +
                '"estimatedDeliveryDate":"' + Format(EstimatedDate, 0, 9) + '"' +
                '}'
        else
            ResponsePayload :=
                '{' +
                '"success":false,' +
                '"message":"Delivery information could not be calculated."' +
                '}';
    end;
}
