CLASS lhc_BookSuppl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
       keys FOR BookSuppl~calculateTotalPrice.

ENDCLASS.

CLASS lhc_BookSuppl IMPLEMENTATION.

  METHOD calculateTotalPrice.

        modiFY entities of zats_vj_m_travel in local mode
        entity travel
            execute calcTotalPrice
                from corRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.
