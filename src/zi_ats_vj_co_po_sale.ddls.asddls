@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po and sales composite view'
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #FACT
@Metadata.ignorePropagatedAnnotations: false
define view entity ZI_ATS_VJ_CO_PO_SALE as select from ZI_ATS_VJ_SALES as Sales
association of many to one ZI_ATS_VJ_PRODUCT as _po on
$projection. Product = _po.ProductId
{
    key ItemId,
    OrderId,
    Product,
    Amount,
    Currency,
    Qty,
    Uom,
    /* Associations */
 
    _header.buyer as buyer,
   
    _po.Name as ProductName,
    _po.Category as ProductCategory
   
}
