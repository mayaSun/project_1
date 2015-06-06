$(document).on("ready page:load", function($) {
  jQuery('select#order_country_code').on('change', function(event) {
    var country_code, select_wrapper, url;
    select_wrapper = jQuery('#order_state_code_wrapper');
    jQuery('select', select_wrapper).attr('disabled', true);
    country_code = jQuery(this).val();
    url = "/subregion_options?parent_region=" + country_code;
    return select_wrapper.load(url);
  });
  return jQuery('select#locale').change(function(event) {
    return jQuery(this).closest('form').submit();
  });
}); 