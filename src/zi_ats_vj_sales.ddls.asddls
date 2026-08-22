@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pure Trans Data basic interface fact'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #FACT
@Metadata.ignorePropagatedAnnotations: false
define view entity ZI_ATS_VJ_SALES as select from zats_vj_so_item
association of one to one zats_vj_so_hdr as _header on
$projection.OrderId = _header.order_id
{

key item_id as ItemId,
order_id as OrderId,
product as Product,
amount as Amount,
currency as Currency,
qty as Qty,
uom as Uom,
_header
    
}
