


CLASS ztest_vj_clas DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS ztest_vj_clas IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*   DATA lt_bpa TYPE STANDARD TABLE OF zats_vj_bpa.
*
*    lt_bpa = VALUE #(
*      ( bp_id = '3ECE2E5790C11FE1A787FF21845335CD' bp_role = '01' company_name = 'TACUM'                      street = 'Victoria Street' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF21845355CD' bp_role = '01' company_name = 'SAP'                        street = 'Rosvelt Street Road' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF21845375CD' bp_role = '01' company_name = 'Asia High tech'             street = '1-7-2 Otemachi' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF21845395CD' bp_role = '01' company_name = 'AVANTEL'                    street = 'Bosque de Duraznos' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF218453B5CD' bp_role = '01' company_name = 'Pear Computing Services'    street = 'Dunwoody Xing' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF218453D5CD' bp_role = '01' company_name = 'PicoBit'                    street = 'Fith Avenue' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF218453F5CD' bp_role = '01' company_name = 'TACUM'                      street = 'Victoria Street' )
*      ( bp_id = '3ECE2E5790C11FE1A787FF21845415CD' bp_role = '01' company_name = 'Indian IT Trading Company'  street = 'Nariman Point' )
*    ).
*
*    INSERT zats_vj_bpa FROM TABLE @lt_bpa.
*
*    IF sy-subrc = 0.
*      out->write( |{ lines( lt_bpa ) } rows inserted successfully.| ).
*    ELSE.
*      out->write( |Insert failed, sy-subrc = { sy-subrc }.| ).
*    ENDIF.

  DELETE FROM zats_vj_bpa.
    out->write( |Rows deleted, table cleared.| ).

     DELETE FROM zats_vj_product.
    out->write( |Rows deleted, table cleared.| ).

     DELETE FROM zats_vj_so_hdr.
    out->write( |Rows deleted, table cleared.| ).

       DELETE FROM zats_vj_so_item.
    out->write( |Rows deleted, table cleared.| ).

  ENDMETHOD.
ENDCLASS.
