CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksuppl FOR NUMBERING
       entities FOR CREATE Booking\_Booksuppl.

        METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Booking RESULT result.

    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      keys FOR booking~calculatetotalprice.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Booksuppl.
    ""HOMEWORK: Implement logic to generate supplement id's as starring point of booking
    ""id and +1
    data max_booking_suppl_id type /dmo/booking_supplement_id.

    ""Step 1 : get all the travel request and their booking data
    read entities of zats_VJ_m_travel in local mode
            entity booking by \_BookSuppl
            from corrESPONDING #( entities )
            link data(booking_supplements).

    ""Loop at unique travel id
    loop at entities assIGNING fiELD-SYMBOL(<booking_group>) group by <booking_group>-%tky.

        ""Step 2: get the higest booking supplement number which is already there
        loop at booking_supplements into data(ls_booking) using key entity where
                                                           source-TravelId = <booking_group>-TravelId and
                                                           source-bookingid = <booking_group>-BookingId.
            if max_booking_suppl_id < ls_booking-target-BookingSupplementId.
                max_booking_suppl_id = ls_booking-target-BookingId.
            endIF.
        endLOOP.

        ""Step 3: get the assigned booking suppplement numbers from incoming request
        loop at entities into data(ls_entity) using key entity
                                                    where travelid = <booking_group>-TravelId and
                                                          bookingid = <booking_group>-BookingId.

            loop at ls_entity-%target into data(ls_target).
                if max_booking_suppl_id < ls_target-BookingId.
                    max_booking_suppl_id = ls_target-BookingId.
                endIF.
            endloop.

        endloop.

        ""Step 4: loop at all the entities of travel with save travel id
        loop at entities assIGNING fiELD-SYMBOL(<booking>) using key entity
                                                    where travelid = <booking_group>-TravelId and
                                                          bookingid = <booking_group>-BookingId.
            ""Step 5: assign the new suimmplement id inside each travel => booking => supplement
            loop at <booking>-%target assIGNING fiELD-SYMBOL(<bookingsuppl_wo_numbers>).
                append corRESPONDING #( <bookingsuppl_wo_numbers> ) to mapped-booksuppl
                                            assIGNING fiELD-SYMBOL(<mapped_supplement>).

                if <mapped_supplement>-BookingSupplementId is iniTIAL.
                    max_booking_suppl_id += 1.
                    <mapped_supplement>-BookingSupplementId = max_booking_suppl_id.
                endIF.

            endloop.
        endloop.
    endloop.


  ENDMETHOD.

  METHOD get_instance_features.

    ""Step 1: Read the data using EML
    READ ENTITIES OF zats_vj_m_travel in local mode
        entity booking
            fields ( bookingid CarrierId )
            with corRESPONDING #(   keys )
            result data(lt_bookings)
            failed failed.

    result = VALUE #(
      FOR ls_booking IN lt_bookings
        ( %tky = ls_booking-%tky
          %features-%field-ConnectionId =
            COND #(
              WHEN ls_booking-CarrierId ne 'AA'
              THEN if_abap_behv=>fc-f-read_only
              ELSE if_abap_behv=>fc-f-unrestricted
            )
        )
    ).

  ENDMETHOD.

  METHOD calculateTotalPrice.

        modiFY entities of zats_vj_m_travel in local mode
        entity travel
            execute calcTotalPrice
                from corRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.
