CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
       entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD augment_create.
  data : travel_create type table for create zats_vj_m_travel.

    travel_create = corrESPONDING #( entities ).

    loop at travel_create assIGNING fieLD-SYMBOL(<travel>).

        <travel>-AgencyId = '70003'.
        <travel>-OverallStatus = 'O'.
        <travel>-%control-AgencyId = if_abap_behv=>mk-on.
        <travel>-%control-OverallStatus = if_abap_behv=>mk-on.

    endloop.
    modIFY augmenting entities of zats_vj_m_travel
        entity travel
        create from travel_create.

  ENDMETHOD.

ENDCLASS.
