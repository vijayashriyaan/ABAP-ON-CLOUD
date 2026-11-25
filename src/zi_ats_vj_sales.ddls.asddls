@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pure transaction, basic, interface, fact'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #BASIC
@Analytics.dataCategory: #FACT
define view entity ZI_ATS_VJ_SALES as select from zats_vj_so_item 
association of one to one zats_vj_so_hdr as _Header on 
$projection.OrderId = _Header.order_id
{
    key item_id as ItemId,
    order_id as OrderId,
    product as Product,
    amount as Amount,
    currency as Currency,
    qty as Qty,
    uom as Uom,
    _Header
    
}

