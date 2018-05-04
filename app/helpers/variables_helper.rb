module VariablesHelper
  def month_points
    board_user = set_user
    board_user.calculate_current_month_points
  end

  def year_points
    board_user = set_user
    board_user.calculate_year_points
  end

  def admin_graph(variable, type)
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

  def gauge_graph(variable, max = 0, value = 0)
    interval = max / 4
    percent = max / 100

    label_options = if variable.tipo == 'moneda'
                      'symbolPosition: "left",'\
                      "maxLabelPrepend: '#{variable.graph_options[:symbol]}',"\
                      "minLabelPrepend: '#{variable.graph_options[:symbol]}',"\
                    else
                      "minLabelAppend: '#{variable.graph_options[:symbol]}',"\
                      "maxLabelAppend: '#{variable.graph_options[:symbol]}',"\
                    end

    '<script>'\
      'var g = new JustGage({'\
        "id: 'gauge_#{variable.id}',"\
        "value: #{value},"\
        "symbol: '#{variable.graph_options[:symbol]}',"\
        "#{label_options}"\
        'min: 0,'\
        'humanFriendly: true,'\
        'relativeGaugeSize: true,'\
        "max: #{max},"\
        'customSectors: ['\
          '{'\
            'color : "#ff0000",'\
            'lo : 0,'\
            "hi : #{interval / 2}"\
          '},{'\
            'color : "#fa8801",'\
            "lo : #{interval / 2},"\
            "hi : #{interval}"\
          '},'\
          '{'\
            'color : "#f9c802",'\
            "lo : #{interval},"\
            "hi : #{interval * 2}"\
          '},{'\
            'color : "#f7da02",'\
            "lo : #{interval * 2},"\
            "hi : #{(interval * 2) + (interval / 2)}"\
          '},'\
          '{'\
            'color : "#d4ce06",'\
            "lo : #{(interval * 2) + (interval / 2)},"\
            "hi : #{(interval * 4) - percent}"\
          '},'\
          '{'\
            'color : "#a9d70b",'\
            "lo : #{(interval * 4) - percent},"\
            "hi : #{max}"\
          '}'\
        '],'\
        'pointer: true'\
      '});'\
    '</script>'
  end

  def inverse_gauge_graph(variable, max = 0, value = 0)
    interval = max / 4
    percent = max / 100

    label_options = if variable.tipo == 'moneda'
                      'symbolPosition: "left",'\
                      "maxLabelPrepend: '#{variable.graph_options[:symbol]}',"\
                      "minLabelPrepend: '#{variable.graph_options[:symbol]}',"\
                    else
                      "minLabelAppend: '#{variable.graph_options[:symbol]}',"\
                      "maxLabelAppend: '#{variable.graph_options[:symbol]}',"\
                    end

    '<script>'\
      'var g = new JustGage({'\
        "id: 'gauge_#{variable.id}',"\
        "value: #{value},"\
        "symbol: '#{variable.graph_options[:symbol]}',"\
        "#{label_options}"\
        'min: 0,'\
        'humanFriendly: true,'\
        'relativeGaugeSize: true,'\
        "max: #{max},"\
        'customSectors: ['\
          '{'\
            'color : "#a9d70b",'\
            'lo : 0,'\
            "hi : #{interval / 2}"\
          '},{'\
            'color : "#d4ce06",'\
            "lo : #{interval / 2},"\
            "hi : #{interval}"\
          '},'\
          '{'\
            'color : "#f7da02",'\
            "lo : #{interval},"\
            "hi : #{interval * 2}"\
          '},{'\
            'color : "#f9c802",'\
            "lo : #{interval * 2},"\
            "hi : #{(interval * 2) + (interval / 2)}"\
          '},'\
          '{'\
            'color : "#fa8801",'\
            "lo : #{(interval * 2) + (interval / 2)},"\
            "hi : #{(interval * 4) - percent}"\
          '},'\
          '{'\
            'color : "#ff0000",'\
            "lo : #{(interval * 4) - percent},"\
            "hi : #{max}"\
          '}'\
        '],'\
        'pointer: true'\
      '});'\
    '</script>'
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
