@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity for travel processor'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
define root view entity ZATS_VJ_M_TRAVEL_PROCESSOR 
provider contract transactional_query
 as projection on ZATS_VJ_M_R_TRAVEL
{
    key TravelId,
    AgencyId,
    CustomerId,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Agency,
    _BOOKING: redirected to composition child ZATS_VJ_M_BOOKING_PROCESSOR,
    _currency,
    _customer,
    _OVERALLSTATUS
}
