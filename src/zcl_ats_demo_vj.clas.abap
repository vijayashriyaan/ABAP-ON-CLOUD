CLASS zcl_ats_demo_vj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_demo_vj IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

   out->write( data = 'Hello World' ).

   select * from  I_EXCHANGERATERAWDATA into TABLE @DATA(itab) UP TO 2 ROWS.

out->write( data = itab ).


  ENDMETHOD.
ENDCLASS.
