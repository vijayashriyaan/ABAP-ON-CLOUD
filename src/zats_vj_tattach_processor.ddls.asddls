@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Processor projection for attachment'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define view entity ZATS_VJ_TATTACH_PROCESSOR as projection on ZATS_VJ_M_TATTACH
{
    key Travelid,
    key  Id,
    Memo,
    Attachment,
    Filename,
    Filetype,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Travel : redirected to parent ZATS_VJ_M_TRAVEL_PROCESSOR
}
