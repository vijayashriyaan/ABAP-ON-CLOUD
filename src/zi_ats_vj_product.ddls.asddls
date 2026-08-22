@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product cds basic and dimesssion'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.ignorePropagatedAnnotations: false
define view entity ZI_ATS_VJ_PRODUCT as select from zats_vj_product
{
    key product_id as ProductId,
    name as Name,
    category as Category,
    price as Price,
    currency as Currency,
    discount as Discount
}
