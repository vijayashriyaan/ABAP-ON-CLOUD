@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suplmentary as grndchild'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
define view entity ZATS_VJ_M_BOOKSUPPL as select from /dmo/booksuppl_m

--composition[1..*] of ZATS_VJ_ as _

association to parent ZATS_VJ_M_BOOKING as _BOOKING on 
$projection.TravelId = _BOOKING.TravelId and 
$projection.BookingId = _BOOKING.BookingId

association[1..1] to ZATS_VJ_M_R_TRAVEL as _travel on
$projection.TravelId =  _travel.TravelId

association [0..1] to /DMO/I_Supplement as _product on 
$projection.SupplementId = _product.SupplementID

--association [1..1] to /DMO/I_SupplementText as _producttext on 
--$projection.SupplementId = _producttext.SupplementID

association [0..*] to /DMO/I_SupplementText as _producttext on
    $projection.SupplementId = _producttext.SupplementID
  

{
key /dmo/booksuppl_m.travel_id as TravelId,
key /dmo/booksuppl_m.booking_id as BookingId,
key /dmo/booksuppl_m.booking_supplement_id as BookingSupplementId,
/dmo/booksuppl_m.supplement_id as SupplementId,
@Semantics.amount.currencyCode: 'CurrencyCode'
/dmo/booksuppl_m.price as Price,
/dmo/booksuppl_m.currency_code as CurrencyCode,
 @Semantics.systemDateTime.lastChangedAt: true
/dmo/booksuppl_m.last_changed_at as LastChangedAt,

_product,
_producttext,
_BOOKING,
_travel

    
}
