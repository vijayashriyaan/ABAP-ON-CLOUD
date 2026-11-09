@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity projection layer'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define root view entity ZATS_VJ_M_TRAVEL_PROCESSOR as projection on ZATS_VJ_M_TRAVEL
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
    /* Associations */
    _Agency,
    _Booking: redirected to composition child ZATS_VJ_M_BOOKING_PROCESSOR,
    _Attachment: redirected to composition child ZATS_VJ_TATTACH_PROCESSOR,
    _Currency,
    _Customer,
    _OverallStatus,
    AgencyName,
    CustomerName,
    StatusText,
    Minion,
    ImageUrl,
    
    
   @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ATS_VJ_VE_CALC'
   @EndUserText.label: 'Co2 Tax'
    virtual CO2Tax : abap.int4,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ATS_VJ_VE_CALC'
    @EndUserText.label: 'Day'
    virtual dayOfTravel: abap.char(9)
}
