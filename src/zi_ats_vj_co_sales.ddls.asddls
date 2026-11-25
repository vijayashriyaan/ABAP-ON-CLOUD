@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales and Product'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #FACT
define view entity ZI_ATS_VJ_CO_SALES as select from ZI_ATS_VJ_SALES as Sales
association of many to one ZI_ATS_VJ_PRODUCT as _Product
on $projection.Product = _Product.ProductId
{
    key ItemId,
    OrderId,
    Product,
    Amount,
    Currency,
    Qty,
    Uom,
    /* Associations */
    _Header.buyer as Buyer,
    _Product.Category as ProductCategory,
    _Product.Name as ProductName
    
}
