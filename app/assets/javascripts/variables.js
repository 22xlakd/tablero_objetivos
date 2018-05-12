/* globals idx Chart */

jQuery( document ).ready(function() {
    var randomScalingFactor = function(){ return Math.round(Math.random()*1000)};
    var barChartData = {
        labels : ["Sucursal Macachin","Sucursal Salliquelo","Sucursal 30 de agosto","Sucursal Anguil","Sucursal Guatrache","Sucursal Casbas","Sucursal General Pico"],
        datasets : [
            {
                label: 'Ventas totales',
                backgroundColor: "rgba(220,33,27,0.5)",
                borderColor: "rgba(220,33,27,0.8)",
                borderWidth: 1,
                data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
            },
            {
                label: 'Facturacion',
                backgroundColor: "rgba(48, 164, 255, 0.2)",
                borderColor: "rgba(48, 164, 255, 0.8)",
                borderWidth: 1,
                data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
            }
        ]

    }
    var chart2 = document.getElementById("bar-chart").getContext("2d");
    var barGraph = new Chart(chart2, {
        type: "bar",
        data: barChartData,
        options: {
            leyend: {
                display: true
            },
            title: {
                display: true,
                text: "Prueba, ksjkjkj"
            },
            responsive: true,
            scaleLineColor: "rgba(0,0,0,.2)",
            scaleGridLineColor: "rgba(0,0,0,.05)",
            scaleFontColor: "#c5c7cc"
        }
    });
});

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
