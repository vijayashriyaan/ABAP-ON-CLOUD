@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Sales by Dimentions'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity ZC_ATS_VJ_TOT_QUAN as select from ZI_ATS_VJ_CO_SLS_CUBE
{
    @EndUserText.label: 'Spiderman'
    key ProductCategory,
    @EndUserText.label: 'Customer'
    key CompanyName,
    @EndUserText.label: 'Place of Order'
    key Country,
    @EndUserText.label: 'Unit of Measure'
    key Uom as UnitofMeasure,
    @EndUserText.label: 'Quantity Sold'
    Qty as QuantitySold
    
}
