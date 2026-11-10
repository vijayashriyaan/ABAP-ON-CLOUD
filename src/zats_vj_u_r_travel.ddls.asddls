@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unmanaged root entity of travel'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZATS_VJ_U_R_TRAVEL
  as select from /dmo/travel as travel
  association [1] to ZATS_VJ_U_AGENCY        as _Agency       on $projection.AgencyId = _Agency.AgencyId
  association [1] to ZATS_VJ_U_CUSTOMER      as _Customer     on $projection.CustomerId = _Customer.CustomerId
  association [1] to I_Currency              as _Currency     on $projection.CurrencyCode = _Currency.Currency
  association [1] to /DMO/I_Travel_Status_VH as _TravelStatus on $projection.Status = _TravelStatus.TravelStatus
{

      @ObjectModel.text.element: [ 'Memo' ]
  key travel.travel_id                                                  as TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZATS_VJ_U_AGENCY' ,
                element : 'AgencyId' }
      }]
      travel.agency_id                                                  as AgencyId,
      _Agency.Name                                                      as AgencyName,

      @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZATS_VJ_U_CUSTOMER' ,
                element : 'CustomerId' }
      }]
      travel.customer_id                                                as CustomerId,
      _Customer.LastName                                                as CustomerName,
      travel.begin_date                                                 as BeginDate,
      travel.end_date                                                   as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      travel.booking_fee                                                as BookingFee,
      @Semantics.amount.currencyCode :'CurrencyCode'
      travel.total_price                                                as TotalPrice,
      @ObjectModel.text.element: [ 'CurrencyName' ]
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'I_Currency' ,
                element : 'CurrencyCode' }
      }]
      travel.currency_code                                              as CurrencyCode,
      _Currency._Text[Language = $session.system_language].CurrencyName as CurrencyName,
      travel.description                                                as Memo,
      @ObjectModel.text.element: [ 'StatusText' ]
      @Consumption.valueHelpDefinition: [{
     entity: { name: '/DMO/I_Travel_Status_VH', element: 'TravelStatus' }
      }]
      travel.status                                                     as Status,
     _TravelStatus._Text[Language = $session.system_language].Text as StatusText,
      travel.createdby                                                  as Createdby,
      travel.createdat                                                  as Createdat,
      travel.lastchangedby                                              as Lastchangedby,
      travel.lastchangedat                                              as Lastchangedat,
      _Agency,
      _Customer,
      _Currency ,
      _TravelStatus
      

}
