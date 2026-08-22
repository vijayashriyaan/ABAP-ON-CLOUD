@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Patner Dimension Basic I_View'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.ignorePropagatedAnnotations: false
define view entity ZI_ATS_VJ_BP as select from zats_vj_bpa
{
    key bp_id as BpId,

    case bp_role
        when '01' then 'Customer'
        when '02' then 'Supplier'
        when '03' then 'employee'
        else 'Unknown'
    end as bp_type,

    company_name as CompanyName,
    country       as Country

    
}where bp_role = '01'
