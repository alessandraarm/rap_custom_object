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
      RETURNING VALUE(rv_docnum) TYPE /dmo/agency_d
      RAISING
                cx_rap_query_provider .
ENDCLASS.



CLASS zcl_rap_custom_object IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA lt_values TYPE tt_values.

    DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
    DATA(lv_top) = io_request->get_paging( )->get_page_size( ).

    TRY.
        IF io_request->is_data_requested( ).

          lt_values = VALUE #( ( travel_id = '1' description = 'Teste1' status = 'C' )
                               ( travel_id = '2' description = 'Teste2' status = 'C' )
                               ( travel_id = '3' description = 'Teste3' status = 'A' ) ).

          io_response->set_total_number_of_records( lines( lt_values ) ).
          io_response->set_data( lt_values ).
        ENDIF.

      CATCH cx_rap_query_provider INTO DATA(lx_exc).
        RAISE EXCEPTION TYPE lc_exception
          EXPORTING
            textid = VALUE scx_t100key( msgid = 'ZSD' msgno = 005 ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_filter.
    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).

        TRY.
            DATA(ls_filter) = lt_filter_cond[ 1 ].
            DATA(ls_value) = ls_filter-range[ 1 ].
            "rv_docnum = ls_value-low.
          CATCH cx_sy_itab_line_not_found.
            RAISE EXCEPTION TYPE lc_exception
              EXPORTING
                textid = VALUE scx_t100key( msgid = 'ZSD' msgno = 006 ).
        ENDTRY.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
        RAISE EXCEPTION TYPE lc_exception
          EXPORTING
            textid = VALUE scx_t100key( msgid = 'ZSD' msgno = 006 ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
