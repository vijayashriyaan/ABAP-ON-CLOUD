@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Sales by Dimentions'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity ZC_ATS_VJ_TOT_SALES as select from ZI_ATS_VJ_CO_SLS_CUBE
{
    
    key ProductCategory,
    key CompanyName,
    key Country,
    key Currency,
    Amount
    
}
