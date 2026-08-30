@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Processor for booking supliment'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
define view entity ZATS_VJ_M_BOOKSUPPL_PROCESSOR 
--provider contract transactional_query
as projection on ZATS_VJ_M_BOOKSUPPL
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _BOOKING: redirected to parent  ZATS_VJ_M_BOOKING_PROCESSOR,
    _product,
    _producttext,
    _travel : redirected to ZATS_VJ_M_TRAVEL_PROCESSOR
}
