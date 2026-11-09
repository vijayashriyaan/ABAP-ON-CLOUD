@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking processor'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity ZATS_VJ_M_BOOKING_APPROVER as projection on ZATS_VJ_M_BOOKING
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    BookingStatusText,
    AirlineName,
    CustomerName,
    /* Associations */
    _BookStatus,
  // _BookSuppl: redirected to composition child ZATS_VJ_M_BOOKSUPPL_APPROVER,
    _Carrier,
    _Connection,
    _Currency,
    _Customer,
    _Travel: redirected to parent ZATS_VJ_M_TRAVEL_APPROVER
}
