/* globals idx Chart idx2 */
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
    if(jQuery(newTab).find(".row").length > 1){
        jQuery(newTab).find(".row").first().remove()
    }
    jQuery(newTab).attr("id", "tab_" + idx)
    jQuery(newTab).removeClass("hidden")
    jQuery(newTab).find(".panel-heading.accordion-header").attr("id", "heading_" + idx)
    jQuery(newTab).find(".lnk-username").attr("href", "#collapse_" + idx)
    jQuery(newTab).find(".lnk-username").attr("aria-controls", "collapse_" + idx)
    var input_obj_id = jQuery(newTab).find(".lnk-username input[type='hidden']")
    input_obj_id.attr("id", "variable_objetivos_attributes_" + idx2  + "_id")
    input_obj_id.attr("name", "variable[objetivos_attributes][" + idx2  + "][id]")
    input_obj_id.val('')
    //var input_usr_id = '<input value="' + jQuery('#usuario_id').val() + '" type="hidden" name="variable[objetivos_attributes][' + idx2 + '][user_id]" id="variable_objetivos_attributes_' + idx2 + '_user_id" />'
    jQuery(newTab).find(".lnk-username").html(jQuery('#usuario_id option:selected').text())
    //jQuery(newTab).find(".lnk-username").append( input_obj_id)
    //jQuery(newTab).find(".lnk-username").append( input_usr_id)
    jQuery(newTab).find(".collapse").attr("id","collapse_" + idx)
    jQuery(newTab).find(".collapse").attr("aria-labelledby","heading_" + idx)
    jQuery(newTab).find("#variable_objetivos_attributes_"+idx2+"_user_id").val(jQuery('#usuario_id').val())

    jQuery(newTab).find("label").each(function(){
       jQuery(this).attr("for", jQuery(this).attr("for").replace(/[0-9]+/g, idx2))
    });

    jQuery(newTab).find("select").each(function(){
       jQuery(this).attr("id", jQuery(this).attr("id").replace(/[0-9]+/g, idx2))
       jQuery(this).attr("name", jQuery(this).attr("name").replace(/[0-9]+/g, idx2))
       jQuery(this).val(jQuery(this)[0].options[0].value)
    });
    
    jQuery(newTab).find("input[type!='hidden']").each(function(){
       jQuery(this).attr("id", jQuery(this).attr("id").replace(/[0-9]+/g, idx2))
       jQuery(this).attr("name", jQuery(this).attr("name").replace(/[0-9]+/g, idx2))
       jQuery(this).val("")
    });

    jQuery("#btn_date_obj_"+idx).unbind('click')
    jQuery("#btn_date_obj_"+idx).bind('click', function(){ addDateObjetive(idx); });
    jQuery(parentSelector).after(newTab);
    jQuery("#collapse_" + idx).collapse('show');
    jQuery('#addObjectiveToUser').modal('hide');

}

function addDateObjetive(row_number){
    var orig_row = jQuery("#user_obj_" + row_number);
    var cloned_row = orig_row.clone();
    idx2++;

    cloned_row.attr("id", "user_obj_" + idx2);
    cloned_row.find("label").each(function(){
       jQuery(this).attr("for", jQuery(this).attr("for").replace(/[0-9]+/g, idx2))
    });

    cloned_row.find("select").each(function(){
       jQuery(this).attr("id", jQuery(this).attr("id").replace(/[0-9]+/g, idx2))
       jQuery(this).attr("name", jQuery(this).attr("name").replace(/[0-9]+/g, idx2))
       jQuery(this).val(jQuery(this)[0].options[0].value)
    });
    
    cloned_row.find("input").each(function(){
       jQuery(this).attr("id", jQuery(this).attr("id").replace(/[0-9]+/g, idx2))
       jQuery(this).attr("name", jQuery(this).attr("name").replace(/[0-9]+/g, idx2))
    });

    cloned_row.find("input[type!='hidden']").each(function(){
        jQuery(this).val("");
    });

    cloned_row.find("#variable_objetivos_attributes_"+idx2+"_id").each(function(){
        jQuery(this).val("");
    });

    cloned_row.find("button").each(function(){
       jQuery(this).attr("id", jQuery(this).attr("id").replace(/[0-9]+/g, idx2))
       jQuery(this).unbind("click");
       jQuery(this).bind("click", function(){ addDateObjetive(idx2); });
    });

    cloned_row.insertAfter(orig_row);
}
