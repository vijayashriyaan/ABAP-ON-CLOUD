CLASS lsc_zats_vj_m_travel DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zats_vj_m_travel IMPLEMENTATION.

  METHOD save_modified.
  data : it_travel_log_upd TYPE STANDARD TABLE OF  /dmo/log_travel,
         it_final_changes TYPE STANDARD TABLE OF  /dmo/log_travel.
"step1 : check if the operation is update only .

if update-travel is not INITIAL.
it_travel_log_upd = CORRESPONDING #( update-travel MAPPING travel_id = TravelId ).
LOOP AT update-travel ASSIGNING FIELD-SYMBOL(<fs_travel_log_upd>).
ASSIGN it_travel_log_upd[ travel_id = <fs_travel_log_upd>-TravelId ]
       to FIELD-SYMBOL(<fs_travel_log_db>).
GET TIME STAMP FIELD <fs_travel_log_db>-created_at.
if <fs_travel_log_upd>-%control-customerId = if_abap_behv=>mk-on.
<fs_travel_log_db>-change_id = cl_system_uuid=>create_uuid_x16_static(
  ).
<fs_travel_log_db>-changed_field_name = 'Vijaya_Customer'.
<fs_travel_log_db>-changed_value = <fs_travel_log_upd>-CustomerId.
<fs_travel_log_db>-changing_operation = 'change'.
APPEND <fs_travel_log_db> to it_final_changes.

 ENDIF..

 if <fs_travel_log_upd>-%control-AgencyId = if_abap_behv=>mk-on.
<fs_travel_log_db>-change_id = cl_system_uuid=>create_uuid_x16_static(
  ).
<fs_travel_log_db>-changed_field_name = 'Vijaya_Agency'.
<fs_travel_log_db>-changed_value = <fs_travel_log_upd>-AgencyId.
<fs_travel_log_db>-changing_operation = 'change'.
APPEND <fs_travel_log_db> to it_final_changes.

 ENDIF..

ENDLOOP..

INSERT /dmo/log_travel FROM table @it_final_changes.


endif.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Travel RESULT result.
    METHODS copytravel FOR MODIFY
      keys FOR ACTION travel~copytravel.

     METHODS calctotalprice FOR MODIFY
         keys FOR ACTION travel~calctotalprice.

      METHODS calculatetotalprice FOR DETERMINE ON SAVE
      keys FOR travel~calculatetotalprice.


*    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
*      keys FOR travel~calculatetotalprice.

    METHODS validateheaderdata FOR VALIDATE ON SAVE
      keys FOR travel~validateheaderdata.

    METHODS precheck_create FOR PRECHECK
      entities FOR CREATE travel.

    METHODS precheck_update FOR PRECHECK
      entities FOR UPDATE travel.
    METHODS accepttravel FOR MODIFY
      keys FOR ACTION travel~accepttravel RESULT result.

    METHODS rejecttravel FOR MODIFY
      keys FOR ACTION travel~rejecttravel RESULT result.

   ""A reusable private method with matching io params and types to reuse code
   TYPES :t_entity_create type table for create zats_vj_m_travel\\travel,
          t_entity_update  type table for update zats_vj_m_travel\\travel,
          t_entity_failed   type response for failed early zats_vj_m_travel,
          t_entity_reported type response for reported early zats_vj_m_travel.

  METHODS precheck_vj_reuse
  IMPORTING
  entity_c TYPE t_entity_create OPTIONAL
  entity_u type t_entity_update  OPTIONAL
  EXPORTING
  failed type  t_entity_failed
  reported type t_entity_reported.








    METHODS earlynumbering_cba_Booking FOR NUMBERING
      entities FOR CREATE Travel\_Booking.
    METHODS earlynumbering_create FOR NUMBERING
      entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.

  DATA :LS_RESULT like line of result.
   "Step 1: Read the data for which we need to check
  READ ENTITIES OF zats_vj_m_travel IN LOCAL MODE
  ENTITY TRAVEL
  FIELDS (  TravelId OverallStatus )
  WITH CORRESPONDING #( KEYS )
  RESULT DATA(IT_TRAVEL)
  FAILED DATA(LS_TRAVEL).

  "Step 2: loop at the data which user is trying to edit
  LOOP AT IT_TRAVEL INTO DATA(LS_TRAVELS).

  "Step 3: Check if the travel request is rejected
  IF ( ls_travelS-OverallStatus = 'X' ).
  DATA(LV_AUTH) = ABAP_FALSE.
   "Step 4: check if given user is Manager or
   "not, if yes, allow edit of travel req.
   AUTHORITY-CHECK OBJECT 'ZAT_VJ_MGR'
   ID 'ACTVT' FIELD '03'.
   IF ( SY-SUBRC = 0 ).
   LV_AUTH = ABAP_TRUE.
   ENDIF.

  ELSE.
  LV_AUTH  = ABAP_TRUE.
  ENDIF.

  ls_result = value #( travelid = ls_travelS-TravelId
                             %update = COND #( when lv_auth eq abap_False
                                                    then if_abap_behv=>auth-unauthorized
                                                    else if_abap_behv=>auth-allowed
                                             )
                            %action-Edit = COND #( when lv_auth eq abap_False
                                                    then if_abap_behv=>auth-unauthorized
                                                    else if_abap_behv=>auth-allowed
                                             )
        ).

APPEND LS_RESULT TO RESULT.






  ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD earlynumbering_create.

    "Step 1: Data type declaration
    data: entity type strUCTURE FOR create zats_VJ_m_travel\\Travel,
          travel_id_max type /dmo/travel_id.


    "Step 2: Ensure that the travel id is not set for any of the record
    loop at entities into entity where travelid is not initial.
        append corrESPONDING #( entity ) to mapped-travel.
    endloop.

    "Step 3: keep the records where travel id is blank - i as a dev take control to generate id
    data(entities_wo_travelid) = entities.
    delete entities_wo_travelid where travelid is not initial.

    "Step 4: get the sequence no from snro --> starring seq no, how many no. 2002 -- 3 numbers
    try.
      "Ctrl+Space and SHift+Enter
      cl_numberrange_runtime=>number_get(
        EXPORTING
          nr_range_nr       = '01'
          object            = conv #( '/DMO/TRAVL' )
          quantity          = CONV #( LINES( entities_wo_travelid ) )
        IMPORTING
          number            = data(number_Range_key)
          returncode        = data(number_range_return_code)
          returned_quantity = data(number_range_return_quantity)
      ).
      CATCH cx_nr_object_not_found into data(lx_not_found).
        loop at entities_wo_travelid into entity.
            append value #( %cid = entity-%cid %key = entity-%key %msg = lx_not_found ) to reported-travel.
            append value #( %cid = entity-%cid %key = entity-%key ) to failed-travel.
        endloop.
      CATCH cx_number_ranges into data(lx_number_range).
        loop at entities_wo_travelid into entity.
            append value #( %cid = entity-%cid %key = entity-%key %msg = lx_number_range ) to reported-travel.
            append value #( %cid = entity-%cid %key = entity-%key ) to failed-travel.
        endloop.
    endtry.


    ""EXTRA BONUS : YOU CAN IGNORE WHILE YOU WORKING - Edge Cases
    case number_range_return_code.
        when '1'.
            ""When number range exceeded a critical threshold
            loop at entities_wo_travelid into entity.
                append value #( %cid = entity-%cid %key = entity-%key
                                %msg = new /dmo/cm_flight_messages(
                                                                   textid = /dmo/cm_flight_messages=>number_range_depleted
                                                                   severity = if_abap_behv_message=>severity-warning
                                                                 )
                                 )
                               to reported-travel.

            endloop.
        when '2' or '3'.
            loop at entities_wo_travelid into entity.
                append value #( %cid = entity-%cid %key = entity-%key
                                %msg = new /dmo/cm_flight_messages(
                                                                   textid = /dmo/cm_flight_messages=>not_sufficient_numbers
                                                                   severity = if_abap_behv_message=>severity-error
                                                                 )
                                 )
                               to reported-travel.
                append value #( %cid = entity-%cid %key = entity-%key
                                %fail-cause = if_abap_behv=>cause-conflict
                                )
                               to failed-travel.
            endloop.

    endCASE.

    ""Step 5 : count the records loop the data and assign number range by incrementing one every time
    assert number_range_return_quantity = lines( entities_wo_travelid ).

    travel_id_max = number_range_key - number_range_return_quantity.

    loop at entities_wo_travelid into entity.

        travel_id_max += 1.
        entity-TravelId = travel_id_max.

*        append value #( %cid = entity-%cid %key = entity-%key ) to mapped-travel.
       append value #( %cid = entity-%cid %key = entity-%key
                        %is_draft = entity-%is_draft ) to mapped-travel.

    endLOOP.



  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    "Step 1: define variable to get max booking id for given travel
    data max_booking_id type /dmo/booking_id.

    "Step 2: Use select query to get the bookings which are already added to travel
*    loop at entities into data(entity).
*        SELECT max( booking_id  ) from /dmo/booking_m where travel_id = ..
*    endloop. ---problemetic - calling a non released object / array operation to fetch booking of every travel
     READ ENTITIES OF ZATS_VJ_M_TRAVEL IN LOCAL MODE
        entity travel by \_Booking
        FROM CORRESPONDING #( entities )
        link data(lt_bookings).

    ""Loop at travel records and assign booking id inside each travel
    loop at entities assigning field-sYMBOL(<travel_group>) group by <travel_group>-TravelId.

        ""Get the highest booking number for booking in this travel request
        loop at lt_bookings into data(ls_booking) using key entity
                                                  where source-TravelId = <travel_group>-TravelId.
            if max_booking_id < ls_booking-target-BookingId.
                max_booking_id = ls_booking-target-BookingId.
            endif.
        endloop.

        "Get the assigned booking number from incoming request
        loop at entities into data(ls_entity) using key entity
                                    where travelid = <travel_group>-TravelId.
             loop at ls_entity-%target into data(ls_target).
                if max_booking_id < ls_target-BookingId.
                    max_booking_id = ls_target-BookingId.
                endif.
             endloop.
        endloop.

        "Loop at entities over all entries and assign a incremented booking id by 10
        loop at entities assIGNING fiELD-SYMBOL(<travel>) using key entity
                                    where travelid = <travel_group>-TravelId.
             loop at <travel>-%target assIGNING fiELD-SYMBOL(<booking_wo_numbers>).
                append corRESPONDING #( <booking_wo_numbers> ) to mapped-booking
                                                assIGNING fiELD-SYMBOL(<mapped_booking>).
                if <mapped_booking>-BookingId is initial.
                    max_booking_id += 10.
                    <mapped_booking>-BookingId = max_booking_id.
                endif.
             endloop.
        endloop.

    endloop.


  ENDMETHOD.

  METHOD get_instance_features.

    ""My manager asked to disable creation of further bookings inside a travel request which is Rejected.

    ""Step 1: Read the data using EML
    READ ENTITIES OF zats_VJ_m_travel in local mode
        entity travel
            fields ( travelid OverallStatus )
            with corRESPONDING #(   keys )
            result data(lt_travels)
            failed failed.

    ""Step 2: return the result with booking creation is possible or not
    read table lt_travels into data(ls_travel) index 1.

    ""Step 3: determine if the status is rejected
     if ( ls_travel-OverallStatus = 'X' ).
        data(lv_allow) = if_abap_behv=>fc-o-disabled.
     else.
        lv_allow = if_abap_behv=>fc-o-enabled.
     endif.

     result = value #( for travel in lt_travels (
                            %tky = travel-%tky
                            %assoc-_Booking = lv_allow
                            %action-acceptTravel = cond #(
                             when travel-OverallStatus = 'A'
                             then  if_abap_behv=>fc-o-disabled
                             else  if_abap_behv=>fc-o-enabled )
             %action-rejectTravel =  cond #(
                             when travel-OverallStatus = 'X'
                             then  if_abap_behv=>fc-o-disabled
                             else  if_abap_behv=>fc-o-enabled )








                         ) ).



  ENDMETHOD.

  METHOD copyTravel.

    ""Step 1: declare new itab where we store data to be created
    data : travels          type table for create zats_VJ_m_travel\\Travel,
           bookings_cba     type table for create zats_VJ_m_travel\\Travel\_Booking,
           booksuppl_cba    type table for create zats_VJ_m_travel\\Booking\_BookSuppl.

    ""Step 2: remove the travel instances with initial %cid
    read table keys with key %cid = '' into data(key_with_initial_cid).
    assert key_with_initial_cid is initIAL.

    ""Step 3: Read all the travel data for incoming travel id
    read entities of zats_VJ_m_travel in local mode
        entity travel
            all fields with corrESPONDING #( keys )
            result data(lt_travel)
            failed failed.

    read entities of zats_VJ_m_travel in local mode
        entity travel by \_Booking
            all fields with corrESPONDING #( lt_travel )
            result data(lt_booking)
            failed failed.

    read entities of zats_VJ_m_travel in local mode
        entity booking by \_BookSuppl
            all fields with corrESPONDING #( lt_booking )
            result data(lt_booksuppl)
            failed failed.

    ""Step 4: loop at the actual data and prepare our table for create new travel req
    loop at lt_travel assIGNING fiELD-SYMBOL(<travel>).

        append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid
                        %data = corrESPONDING #( <travel> except travelid )
        ) to travels assIGNING fIELD-SYMBOL(<new_travel>).

        <new_travel>-BeginDate = cl_abap_Context_info=>get_system_date( ).
        <new_travel>-EndDate = cl_abap_Context_info=>get_system_date( ) + 5.
        <new_travel>-OverallStatus = 'O'.

        ""Step 4.1 Fill the booking internal table for data creation - deep copy
        append value #( %cid_ref =  keys[ %tky = <travel>-%tky ]-%cid
                        ) to bookings_cba assIGNING fiELD-SYMBOL(<bookings_cba>).

        loop at lt_booking assIGNING fiELD-SYMBOL(<booking>) where travelid = <travel>-TravelId.

            append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId
                            %data = corrESPONDING #( lt_booking[ key entity %tky = <booking>-%tky ] except travelid )
                          ) to <bookings_cba>-%target assIGNING fiELD-SYMBOL(<new_booking>).

            <new_booking>-BookingStatus = 'N'.


            append value #( %cid_ref = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId )
                            to booksuppl_cba assIGNING fiELD-SYMBOL(<booksuppl_cba>).

            ""Step 4.2 : fill the supplement data
            loop at lt_booksuppl assIGNING fiELD-SYMBOL(<booksuppl>)
                                        using key entity where
                                                    travelid = <travel>-TravelId and
                                                    bookingid = <booking>-bookingid.
                append value #( %cid = keys[ %tky = <travel>-%tky ]-%cid && <booking>-BookingId && <booksuppl>-BookingSupplementId
                                %data = corrESPONDING #( <booksuppl> exCEPT travelid bookingid )
                            ) to <booksuppl_cba>-%target.

            endloop.

        endloop.



    endLOOP.

    ""Step 5: fire EML to create new data in db
    modIFY entities of zats_VJ_m_travel in local mode
        entity travel
            create fields ( agencyid customerid begindate enddate bookingfee totalprice currencycode overallstatus )
                with travels
            create by \_Booking fields ( bookingid bookingdate customerid carrierid connectionid flightdate
                                         flightprice currencycode bookingstatus )
                with bookings_cba
                    entity booking
                        create by \_BookSuppl fields ( bookingsupplementid supplementid price currencycode )
                            with booksuppl_cba
            mapped data(mapped_create).


    mapped-travel = mapped_create-travel.

    ENDMETHOD.

METHOD calcTotalPrice.

*    Define a structure to store AMT+CURRENCY
     types: beGIN OF ty_amount_per_Currency,
                amount type /dmo/total_price,
                currency_code type /dmo/currency_code,
            end of ty_amount_per_Currency.

*    Create a internal table for that structure
     data: amounts_per_currency type standard table of ty_amount_per_Currency.

*    First add the booking fee to the table
     READ ENTITIES OF ZATS_vj_M_TRAVEL IN LOCAL MODE
        ENTITY Travel
        FIELDS ( BookingFee CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(travels).

*    Read all the bookings inside my travel req. loop at each booking data and conv to common currency and total
     READ ENTITIES OF ZATS_vj_M_TRAVEL IN LOCAL MODE
        ENTITY Travel by \_Booking
        FIELDS ( FlightPrice CurrencyCode )
        WITH CORRESPONDING #( travels )
        RESULT DATA(bookings).

*    Read each of the supplement data, loop at it and convert it to common currency and total
     READ ENTITIES OF ZATS_vj_M_TRAVEL IN LOCAL MODE
        ENTITY Booking by \_BookSuppl
        FIELDS ( Price CurrencyCode )
        WITH CORRESPONDING #( bookings )
        RESULT DATA(bookingsupplements).


     "Delete all records which does not have currency code -- Thorw Exception
     DELETE travels where currencycode is initial.
     DELETE bookings where currencycode is initial.
     DELETE bookingsupplements where currencycode is initial.

*    Total amount will be calculated by summing in common curr (header)
     loop at travels assIGNING fIELD-SYMBOL(<travel>).

        "Set our first value in internal table for booking fee which comes from header
        amounts_per_currency = value #( ( amount = <travel>-BookingFee currency_code = <travel>-CurrencyCode ) ).

        "Loop at booking data and accumulate all bookings total in each currency
        loop at bookings into data(booking) where travelid = <travel>-TravelId.

            collect value ty_amount_per_currency( amount = booking-FlightPrice currency_code = booking-CurrencyCode )
                        into amounts_per_currency.

        endloop.

        loop at bookingsupplements into data(supplement) where travelid = <travel>-TravelId.

            collect value ty_amount_per_currency( amount = supplement-Price currency_code = supplement-CurrencyCode )
                        into amounts_per_currency.

        endloop.

     endloop.

     "loop at each record in our temp table, compare currency at header, if not match convert and total
     clear <travel>-TotalPrice.

     loop at amounts_per_currency into data(amount_per_currency).

        if amount_per_currency-currency_code = <travel>-CurrencyCode.
            <travel>-TotalPrice += amount_per_currency-amount.
        else.

            "currency conversion
            /dmo/cl_flight_amdp=>convert_currency(
              EXPORTING
                iv_amount               = amount_per_currency-amount
                iv_currency_code_source = amount_per_currency-currency_code
                iv_currency_code_target = <travel>-CurrencyCode
                iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
              IMPORTING
                ev_amount               = data(total_amount)
            ).

            <travel>-TotalPrice += total_amount.
        endif.

     endloop.


*    EML to update data in database for the current travel request
      MODIFY ENTITIES OF zats_vj_m_travel in local mode
        entity travel
            update fields ( totalprice )
            with corrESPONDING #( travels ).

*    Return the result data in the output


  ENDMETHOD.

  METHOD calculateTotalPrice.

    modiFY entities of zats_vj_m_travel in local mode
        entity travel
            execute calcTotalPrice
                from corRESPONDING #( keys ).

  ENDMETHOD.

  METHOD validateHeaderData.


    "Read the incoming data
    read eNTITIES OF zats_vj_m_travel in local mode
        entity travel
        fields ( customerid begindate enddate agencyid )
        with corRESPONDING #( keys )
        result data(lt_travel).


    "Declare itab of unique customer id's which needs to be validated
*    data customers type sorTED TABLE OF /dmo/customer with UNIQUE key customer_id.

    data : customers type sorTED TABLE OF /dmo/customer with UNIQUE key customer_id,
           agencies type sorTED TABLE OF /dmo/agency with UNIQUE key agency_id.
    ""unique customer ids in a table
    customers = corrESPONDING #( lt_travel DISCARDING DUPLICATES mapping
                                        customer_id = customerid except *
                                    ).

     agencies = corrESPONDING #( lt_travel DISCARDING DUPLICATES mapping
                                        agency_id = agencyid except *
                                    ).

    delete customers where customer_id is iniTIAL.
    delete agencies where agency_id is iniTIAL.
    ""Call DB to fetch valid customers from master data table
    if customers is not initial.
        select from /dmo/customer fields customer_id
                for all entries in @customers
                    where customer_id = @customers-customer_id
                    into table @data(lt_db_customers).
   endif.
    if agencies is not initial.
        select from /dmo/agency fields agency_id
                for all entries in @agencies
                    where agency_id = @agencies-agency_id
                    into table @data(lt_db_agencies).

    endif.

    loop at lt_travel into data(ls_travel).



        if ( ls_travel-CustomerId is initial or
             not line_exists( lt_db_customers[ customer_id = ls_travel-CustomerId ] )
           ).

            append value #( %tky = ls_travel-%tky ) to failed-travel.
            append value #( %tky = ls_travel-%tky
                            %element-customerid = if_abap_behv=>mk-on
                            %msg = new /dmo/cm_flight_messages(
                                textid = /dmo/cm_flight_messages=>customer_unkown
                                customer_id = ls_travel-CustomerId
                                severity = if_abap_behv_message=>severity-error
                             )
            ) to reported-travel.

        endif.

    ""TODO: Homework
    "1. validate agency
    if ( ls_travel-AGENCYID is initial or
             not line_exists( lt_db_agencies[ agency_id = ls_travel-AGENCYID ] )
           ).

            append value #( %tky = ls_travel-%tky ) to failed-travel.
            append value #( %tky = ls_travel-%tky
                            %element-agencyid = if_abap_behv=>mk-on
                            %msg = new /dmo/cm_flight_messages(
                                textid = /dmo/cm_flight_messages=>agency_unkown
                                customer_id = ls_travel-AgencyId
                                severity = if_abap_behv_message=>severity-error
                             )
            ) to reported-travel.

        endif.
    "2. check if begin and end dates are not blank
    if ( ls_travel-BeginDate is initial or ls_travel-EndDate is initial ).

            append value #( %tky = ls_travel-%tky ) to failed-travel.
            append value #( %tky = ls_travel-%tky
                            %element-begindate = if_abap_behv=>mk-on
                            %element-enddate = if_abap_behv=>mk-on
                            %msg = new /dmo/cm_flight_messages(
                                textid = value #( msgid = 'SY' msgno = 499 attr1 = 'Amigo! the date cannot be empty' )
                                severity = if_abap_behv_message=>severity-error
                             )
            ) to reported-travel.

        endif.

    "3. begin date must be less than end date

    if ( ls_travel-BeginDate > ls_travel-EndDate  ).

            append value #( %tky = ls_travel-%tky ) to failed-travel.
            append value #( %tky = ls_travel-%tky
                            %element-begindate = if_abap_behv=>mk-on
                            %element-enddate = if_abap_behv=>mk-on
                            %msg = new /dmo/cm_flight_messages(
                                textid = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                severity = if_abap_behv_message=>severity-error
                             )
            ) to reported-travel.

        endif.
    "4. begin data must be >= today
    if ( ls_travel-BeginDate < cl_abap_Context_info=>get_system_date( )  ).

            append value #( %tky = ls_travel-%tky ) to failed-travel.
            append value #( %tky = ls_travel-%tky
                            %element-begindate = if_abap_behv=>mk-on
                            %msg = new /dmo/cm_flight_messages(
                                textid = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                severity = if_abap_behv_message=>severity-error
                             )
            ) to reported-travel.

        endif.

    endloop.




  ENDMETHOD.

  METHOD precheck_create.

  precheck_vj_reuse(
    EXPORTING
      entity_c =  ENTITIES
*      entity_u =
    IMPORTING
      failed   = FAILED
     reported = REPORTED
  ).


  ENDMETHOD.

  METHOD precheck_update.

  precheck_vj_reuse(
    EXPORTING

      entity_u = ENTITIES
    IMPORTING
      failed   = FAILED
     reported = REPORTED
  ).

  ENDMETHOD.

  METHOD precheck_vj_reuse.

  "Step 1: data declaration
  data : entities type t_entity_update,
         operation type char1,
         it_agencies type sorTED TABLE OF /dmo/agency with unique key agency_id,
         it_customer type sorTED TABLE OF /dmo/customer with unique key customer_id.

   "Step 2: Check either C or U data was passed
   assert not ( entity_c is initial equiv entity_u is initial ).
"Step 3: perform the validation only if the Agency or customer was changed
if entity_c is not INITIAL.
 entities = CORRESPONDING #( entity_c ).
  operation = if_abap_behv=>op-m-create.
else.

    entities = CORRESPONDING #( entity_u ).
    operation = if_abap_behv=>op-m-update.

endif.
DELETE entities where %control-AgencyId = if_abap_behv=>mk-off and
                     %control-CustomerId = if_abap_behv=>mk-off.


    "Step 4: Get all the unique agencies and customers in our itab to query db later
    it_agencies = CORRESPONDING #( entities DISCARDING DUPLICATES MAPPING agency_id = agencyid EXCEPT * ).
    it_customer = CORRESPONDING #( entities discarding duplicates mapping customer_id = customerid EXCEPT *  ).

    ""Step 5: Check the agency and customer in DB table and fetch the valid one's - get the country codes
     select from /dmo/agency fields agency_id, country_code
        for all entRIES IN @it_agencies where agency_id = @it_agencies-agency_id
        into table @data(it_agency_country_codes).
    select from /dmo/customer fields customer_id, country_code
        for all entRIES IN @it_customer where customer_id = @it_customer-customer_id
        into table @data(it_customer_country_codes).

        LOOP AT entities into data(entity).
        READ TABLE it_agency_country_codes WITH KEY agency_id = entity-AgencyId
        into data(ls_agency).
         READ TABLE it_customer_country_codes WITH KEY customer_id = entity-CustomerId
        into data(ls_customer).

        CHECK sy-subrc = 0 .

        if ls_agency-country_code <> ls_customer-country_code.
         append value #( %cid = cond #(  when operation = if_abap_behv=>op-m-create then entity-%cid_ref )
                            %is_draft = entity-%is_draft
                            %fail-cause = if_abap_behv=>cause-conflict
             ) to failed-travel.
            append value #( %cid = cond #(  when operation = if_abap_behv=>op-m-create then entity-%cid_ref )
                            %is_draft = entity-%is_draft
                            %element-customerid = if_abap_behv=>mk-on
                            %element-agencyid = if_abap_behv=>mk-on
                            %msg = new /dmo/cm_flight_messages(
                                textid = value #( msgid = 'SY' msgno = 499
                                                  attr1 = entity-CustomerId
                                                  attr2 = ' is not have same country as agency '
                                                  attr3 = entity-CustomerId
                                )
                                severity = if_abap_behv_message=>severity-error
                             )
            ) to reported-travel.
        ENDIF.

        ENDLOOP.


  ENDMETHOD.

  METHOD acceptTravel.

  ""Perform the change on BO instance using EML
MODIFY ENTITIES OF zats_vj_m_travel IN LOCAL MODE
entity travel
update FIELDS (  overallstatus  )
with value #( For key in keys (
               %tky = key-%tky
               %is_draft = key-%is_draft
               overallstatus = 'A' ) ).

" ""Read the BO instance again from DB to send back to UI
READ ENTITIES OF zats_vj_m_travel in LOCAL MODE
entity travel
ALL FIELDS WITH CORRESPONDING #(  keys )
RESULT data(it_result).
result = value #(  for travel in it_result ( %tky = travel-%tky
                                %param = travel ) ).
  ENDMETHOD.

  METHOD rejectTravel.

  ""Perform the change on BO instance using EML
MODIFY ENTITIES OF zats_vj_m_travel IN LOCAL MODE
entity travel
update FIELDS (  overallstatus  )
with value #( For key in keys (
               %tky = key-%tky
               %is_draft = key-%is_draft
               overallstatus = 'X' ) ).

" ""Read the BO instance again from DB to send back to UI
READ ENTITIES OF zats_vj_m_travel in LOCAL MODE
entity travel
ALL FIELDS WITH CORRESPONDING #(  keys )
RESULT data(it_result).
result = value #(  for travel in it_result ( %tky = travel-%tky
                                %param = travel ) ).
  ENDMETHOD.

ENDCLASS.
