@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comp view of Bp and sales cube'
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.ignorePropagatedAnnotations :false
define view entity ZI_ATS_VJ_CO_BP_SLS as select from ZI_ATS_VJ_CO_PO_SALE
association of many to one ZI_ATS_VJ_BP as _businespatner  on 
$projection.buyer = _businespatner.BpId
{
    key ItemId,
    OrderId,
    Product,
    @DefaultAggregation: #SUM
    Amount,
    Currency,
    @DefaultAggregation: #SUM
    Qty,
    Uom,
    buyer,
    ProductName,
    ProductCategory,
   _businespatner.CompanyName,
   _businespatner.country
}
