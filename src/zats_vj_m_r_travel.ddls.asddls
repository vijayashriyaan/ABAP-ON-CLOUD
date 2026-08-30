@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel req root entity Manged'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define root view entity ZATS_VJ_M_R_TRAVEL as select from /dmo/travel_m
composition[1..*] of ZATS_VJ_M_BOOKING as _BOOKING
association[1] to /DMO/I_Agency as _Agency on 
$projection.AgencyId = _Agency.AgencyID

association[1] to /DMO/I_Customer as _customer on 
$projection.CustomerId = _customer.CustomerID


association[1] to I_Currency as _currency on 
$projection.CurrencyCode = _currency.Currency


association[1] to /DMO/I_Overall_Status_VH as _OVERALLSTATUS on 
$projection.OverallStatus = _OVERALLSTATUS.OverallStatus

{
    key travel_id as TravelId,
    agency_id as AgencyId,
    customer_id as CustomerId,
    begin_date as BeginDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
    overall_status as OverallStatus,
    
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
     @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    ---_association_name // Make association public
    _Agency,
    _customer,
    
    _currency,
    
    _OVERALLSTATUS,
    
    _BOOKING
}
