CLASS zcl_rap_custom_object DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_values,
             travel_id   TYPE /dmo/travel-travel_id,
             description TYPE /dmo/travel-description,
             status      TYPE /dmo/travel-status,
           END OF ty_values.

    TYPES tt_values TYPE TABLE OF ty_values.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_filter
      IMPORTING io_request       TYPE REF TO if_rap_query_request
      RETURNING VALUE(rv_query) TYPE string
      RAISING   cx_rap_query_provider .
ENDCLASS.



CLASS ZCL_RAP_CUSTOM_OBJECT IMPLEMENTATION.


  METHOD get_filter.
    TRY.
        rv_query = io_request->get_filter( )->get_as_sql_string(  ).

    CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
        RAISE EXCEPTION TYPE lc_exception
          EXPORTING
            textid = VALUE scx_t100key( msgid = 'ZSD' msgno = 006 ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_values TYPE tt_values.

    DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
    DATA(lv_top) = io_request->get_paging( )->get_page_size( ).

    TRY.
        IF io_request->is_data_requested( ).
           DATA(lv_query) = me->get_filter( io_request = io_request ).

             SELECT travel_id, description, status
               FROM /dmo/travel
               WHERE (lv_query)
               ORDER BY travel_id
               INTO TABLE @lt_values
               UP TO @lv_top ROWS
               OFFSET @lv_skip.


*         Informa os dados de saída
          io_response->set_total_number_of_records( lines( lt_values ) ).
          io_response->set_data( lt_values ).
        ENDIF.

      CATCH cx_rap_query_provider INTO DATA(lx_exc).
        RAISE EXCEPTION TYPE lc_exception
          EXPORTING
            textid = VALUE scx_t100key( msgid = 'ZSD' msgno = 005 ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
