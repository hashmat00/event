$ ->
  $('select#order_country_code').change (event) ->
    select_wrapper = $('#order_state_code_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country_code = $(this).val()

    url = "/events/subregion_options?parent_region=#{country_code}"
    select_wrapper.load(url)