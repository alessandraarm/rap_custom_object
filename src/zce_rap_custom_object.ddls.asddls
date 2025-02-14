@EndUserText.label: 'Custom Object'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_RAP_CUSTOM_OBJECT'
    }
}
define root custom entity ZCE_RAP_CUSTOM_OBJECT
{
  key travel_id   : /dmo/travel_id;
      description : /dmo/description;
      status      : /dmo/travel_status;

}
