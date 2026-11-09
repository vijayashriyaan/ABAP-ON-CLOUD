CLASS zcl_ats_vj_ve_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_vj_ve_calc IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

  data : lt_calc_data type standard table of zats_vj_m_travel_processor,
           lv_rate type p deCIMALS 2 value '0.025'.

     lt_calc_data = CORRESPONDING #( it_original_data )      .

     loop at lt_Calc_data assIGNING fiELD-SYMBOL(<fs_calc>).

        <fs_calc>-CO2Tax = <fs_calc>-TotalPrice * lv_rate.
        ""TODO: replace below code with some class in abap which give you day from date
        <fs_calc>-dayOfTravel = 'Sunday'.

     endloop.

     ct_calculated_data = corresponding #( lt_Calc_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
