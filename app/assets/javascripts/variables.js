/* globals idx */
function changeSeparator (idInput) {

  jQuery("#" + idInput).val(jQuery("#" + idInput).val().replace(",", "."));

}

function add_objective(){

    var parentSelector = ''
    var newTab = jQuery("#tab_" + idx).first().clone();
    if (jQuery("#tab_" + idx).hasClass('hidden')) {
        jQuery("#tab_" + idx).remove()
        parentSelector = "#accordion"
    }
    else{
        parentSelector = '.accordion-container:last-child'
    }
    idx += 1;
    jQuery(newTab).attr("id", "tab_" + idx)
    jQuery(newTab).removeClass("hidden")
    jQuery(newTab).find(".panel-heading.accordion-header").attr("id", "heading_" + idx)
    jQuery(newTab).find(".lnk-username").attr("href", "#collapse_" + idx)
    jQuery(newTab).find(".lnk-username").attr("aria-controls", "collapse_" + idx)
    var input_obj_id = jQuery(newTab).find(".lnk-username input[type='hidden']")
    input_obj_id.attr("id", "variable_objetivos_attributes_" + idx  + "_id")
    input_obj_id.attr("name", "variable[objetivos_attributes][" + idx  + "][id]")
    input_obj_id.val('')
    var input_usr_id = '<input value="' + jQuery('#usuario_id').val() + '" type="hidden" name="variable[objetivos_attributes][' + idx + '][user_id]" id="variable_objetivos_attributes_' + idx + '_user_id" />'
    jQuery(newTab).find(".lnk-username").html(jQuery('#usuario_id option:selected').text())
    jQuery(newTab).find(".lnk-username").append( input_obj_id)
    jQuery(newTab).find(".lnk-username").append( input_usr_id)
    jQuery(newTab).find(".collapse").attr("id","collapse_" + idx)
    jQuery(newTab).find(".collapse").attr("aria-labelledby","heading_" + idx)

    jQuery(newTab).find("label").each(function(){
       jQuery(this).attr("for", jQuery(this).attr("for").replace(/[0-9]+/g, idx))
    });

    jQuery(newTab).find("input[type!='hidden']").each(function(){
       jQuery(this).attr("id", jQuery(this).attr("id").replace(/[0-9]+/g, idx))
       jQuery(this).attr("name", jQuery(this).attr("name").replace(/[0-9]+/g, idx))
       jQuery(this).val("")
    });

    jQuery(parentSelector).after(newTab);
    jQuery("#collapse_" + idx).collapse('show');
    jQuery('#addObjectiveToUser').modal('hide');

}
