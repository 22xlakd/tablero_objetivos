module VariablesHelper
  def month_points
    board_user = set_user
    board_user.calculate_current_month_points
  end

  def year_points
    board_user = set_user
    board_user.calculate_year_points
  end

  def best_objective
    board_user = set_user
    best_obj = board_user.best_objective

    best_obj[:value] = if best_obj[:type] == 'entero'
                         best_obj[:value].to_i
                       else
                         number_with_precision(best_obj[:value], precision: 2, separator: ',', delimiter: '.')
                       end

    if !best_obj[:value].nil?
      html_objective = "<div class='row no-padding'>
      <em class='fa fa-xl fa-arrow-up color-green'></em><div class='large'>#{best_obj[:value]}</div>
      <div class='text-muted-dashboard'>#{I18n.t(:best_objective)}: <b>#{best_obj[:name]}</b></div>
      </div>"
      html_objective.html_safe
    else
      ''
    end
  end

  def worst_objective
    board_user = set_user
    worst_obj = board_user.worst_objective

    worst_obj[:value] = if worst_obj[:type] == 'entero'
                          worst_obj[:value].to_i
                        else
                          number_with_precision(worst_obj[:value], precision: 2, separator: ',', delimiter: '.')
                        end

    if !worst_obj[:value].nil?
      html_objective = "<div class='row no-padding'><em class='fa fa-xl fa-arrow-down color-red'></em>
      <div class='large'>#{worst_obj[:value]}</div>
      <div class='text-muted-dashboard'>#{I18n.t(:worst_objective)}: <b>#{worst_obj[:name]}</b></div>
      </div>"
      html_objective.html_safe
    else
      ''
    end
  end

  private

  def set_user
    if params[:codigo_sucursal]
      User.includes(:registros, objetivos: :variable).where(codigo_sucursal: params[:codigo_sucursal]).first
    else
      current_user
    end
  end
end
