/* globals idx */
function changeSeparator (idInput) {

  jQuery("#" + idInput).val(jQuery("#" + idInput).val().replace(",", "."));

}

function add_objective(){

    idx += 1;
    // jQuery('#usuario_id').val();
    var newTab = jQuery("[id^='tab']").clone();
    jQuery(newTab).find(".panel.panel-default.accordion-container").attr("id", "tab_" + idx)
    jQuery('#accordion .accordion-container:last-child').after(newTab);

}
