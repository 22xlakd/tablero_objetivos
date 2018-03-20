// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function hideFlashMessage(selector){

    if (jQuery(selector).length > 0){
        jQuery(selector).fadeOut("slow", "swing");
    }

}
