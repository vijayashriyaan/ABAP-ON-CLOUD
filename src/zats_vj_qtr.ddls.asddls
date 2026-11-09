
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@EndUserText.label: 'Draft query view for ZATS_VJ_DTRAVEL'
define root view entity zats_vj_qtr
  as select from zats_vj_dtravel
{
  key travelid as TravelId,
  agencyid as AgencyId,
  agencyname as AgencyName,
  customerid as CustomerId,
  customername as CustomerName,
  begindate as BeginDate,
  enddate as EndDate,
  bookingfee as BookingFee,
  totalprice as TotalPrice,
  currencycode as CurrencyCode,
  description as Description,
  overallstatus as OverallStatus,
  statustext as StatusText,
  minion as Minion,
  createdby as CreatedBy,
  createdat as CreatedAt,
  lastchangedby as LastChangedBy,
  lastchangedat as LastChangedAt,
  imageurl as ImageUrl,
  draftentitycreationdatetime as draftentitycreationdatetime,
  draftentitylastchangedatetime as draftentitylastchangedatetime,
  draftadministrativedatauuid as draftadministrativedatauuid,
  draftentityoperationcode as draftentityoperationcode,
  hasactiveentity as hasactiveentity,
  draftfieldchanges as draftfieldchanges
}
