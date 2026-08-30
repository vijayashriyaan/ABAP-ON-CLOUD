@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Entity as first chails of travel'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZATS_VJ_M_BOOKING as select from /dmo/booking_m
composition[1..*] of ZATS_VJ_M_BOOKSUPPL as _BOOKSUPPL 

association to parent ZATS_VJ_M_R_TRAVEL as _TRAVEL on 
$projection.TravelId = _TRAVEL.TravelId

association [1] to /DMO/I_Customer as _customer on
$projection.CustomerId =  _customer.CustomerID

association [1] to /DMO/I_Carrier as _carrier on

$projection.CarrierId =  _carrier.AirlineID

association [1] to /DMO/I_Connection as _CONNECTION on
$projection.CarrierId =  _CONNECTION.AirlineID and
$projection.ConnectionId =  _CONNECTION.ConnectionID

association[1] to I_Currency as _currency on 
$projection.CurrencyCode = _currency.Currency

association[1] to /DMO/I_Booking_Status_VH as _BOOKSTATUS on 
$projection.BookingStatus = _BOOKSTATUS.BookingStatus


{


key travel_id as TravelId,
key booking_id as BookingId,
booking_date as BookingDate,
customer_id as CustomerId,
carrier_id as CarrierId,
connection_id as ConnectionId,
flight_date as FlightDate,
@Semantics.amount.currencyCode: 'CurrencyCode'
flight_price as FlightPrice,
currency_code as CurrencyCode,
booking_status as BookingStatus,
 @Semantics.systemDateTime.lastChangedAt: true
last_changed_at as LastChangedAt,

_customer,
_carrier,
_CONNECTION,
_currency,
_BOOKSTATUS,
_TRAVEL,
_BOOKSUPPL 





    
}
