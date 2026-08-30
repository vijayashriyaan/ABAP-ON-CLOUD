@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking projection processor'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
define view entity ZATS_VJ_M_BOOKING_PROCESSOR 
--provider contract transactional_query
as projection on ZATS_VJ_M_BOOKING
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
    /* Associations */
    _BOOKSTATUS,
    _BOOKSUPPL : redirected to composition child ZATS_VJ_M_BOOKSUPPL_PROCESSOR,
    _carrier,
    _CONNECTION,
    _currency,
    _customer,
    _TRAVEL: redirected to parent ZATS_VJ_M_TRAVEL_PROCESSOR
}
