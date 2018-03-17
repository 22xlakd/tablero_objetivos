module VariablesHelper
  def month_points
    current_user.calculate_current_month_points
  end

  def year_points
    current_user.calculate_year_points
  end

  def best_objective
    best_obj = current_user.best_objective

    best_obj[:value] = if best_obj[:type] == 'entero'
                         best_obj[:value].to_i
                       else
                         number_with_precision(best_obj[:value], precision: 2, separator: ',', delimiter: '.')
                       end

    html_objective = "<div class='row no-padding'>
      <em class='fa fa-xl fa-arrow-up color-green'></em><div class='large'>#{best_obj[:value]}</div>
      <div class='text-muted-dashboard'>#{I18n.t(:best_objective)}: <b>#{best_obj[:name]}</b></div>
      </div>"
    html_objective.html_safe
  end

  def worst_objective
    worst_obj = current_user.worst_objective

    worst_obj[:value] = if worst_obj[:type] == 'entero'
                          worst_obj[:value].to_i
                        else
                          number_with_precision(worst_obj[:value], precision: 2, separator: ',', delimiter: '.')
                        end

    html_objective = "<div class='row no-padding'><em class='fa fa-xl fa-arrow-down color-red'></em>
      <div class='large'>#{worst_obj[:value]}k</div>
      <div class='text-muted-dashboard'>#{I18n.t(:worst_objective)}: <b>#{worst_obj[:name]}</b></div>
      </div>"
    html_objective.html_safe
  end
end
