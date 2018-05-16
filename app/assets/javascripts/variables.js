/* globals idx Chart */
/*
jQuery( document ).ready(function() {
    var randomScalingFactor = function(){ return Math.round(Math.random()*1000)};
    var barChartData = {
        labels : [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],
        datasets : [
            {
                label: 'Objetivo Facturación',
                backgroundColor: "rgba(58, 181, 64,0.5)",
                borderColor: "rgba(58, 181, 64,0.8)",
                borderWidth: 1,
                fill: false,
                data : [456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456]
            },
            {
                label: 'Proyección Facturación',
                backgroundColor: "rgba(220,33,27,0.5)",
                borderColor: "rgba(220,33,27,0.8)",
                borderWidth: 1,
                fill: false,
                data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
            },
            {
                label: 'Facturacion Actual',
                backgroundColor: "rgba(48, 164, 255, 0.2)",
                borderColor: "rgba(48, 164, 255, 0.8)",
                borderWidth: 1,
                fill: false,
                data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
            }
        ]

    }
    var chart2 = document.getElementById("bar-chart").getContext("2d");
    var barGraph = new Chart(chart2, {
        type: "line",
        data: barChartData,
        options: {
            title: {
                display: true,
                text: "Facturación"
            },
            responsive: true,
            tooltips: {
                mode: 'index',
                intersect: true,
            },
            hover: {
                mode: 'nearest',
                intersect: true
            },
            scales: {
                xAxes: [{
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'Month'
                    }
                }],
                yAxes: [{
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'Value'
                    }
                }]
            }
        }
    });
});

*/

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
