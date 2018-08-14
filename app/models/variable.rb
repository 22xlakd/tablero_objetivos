class Variable < ActiveRecord::Base
  validates :nombre, presence: true
  validates :puntaje, numericality: { greater_than_or_equal_to: 0 }
  validate :check_variable_type

  has_many :registros
  has_many :objetivos

  after_initialize :init_instance_variables

  VARIABLE_TYPES = %w(porcentaje entero moneda)
  GRAPH_OPTIONS = { porcentaje: { symbol: '%' }, entero: { symbol: '' }, moneda: { symbol: '$' } }
  FONT_FAMILY = "'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'"
  ADMIN_GRAPH_OPTIONS = {
    porcentaje: {
      title: {
        display: true,
        fontSize: 16,
        fontFamily: FONT_FAMILY,
        text: ''
      },
      legend: {
        labels: {
          fontFamily: FONT_FAMILY
        }
      },
      elements: {
        line: {
          tension: 0.4
        }
      },
      tooltips: {
        mode: 'index',
        intersect: true,
        position: 'nearest',
        titleFontFamily: FONT_FAMILY,
        bodyFontFamily: FONT_FAMILY
      },
      responsive: true,
      hover: {
        mode: 'nearest',
        intersect: true
      },
      scales: {
        xAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'Días'
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: ''
          }
        }]
      }
    },
    entero: {
      title: {
        display: true,
        fontSize: 16,
        fontFamily: FONT_FAMILY,
        text: ''
      },
      legend: {
        labels: {
          fontFamily: FONT_FAMILY
        }
      },
      elements: {
        line: {
          tension: 0.4
        }
      },
      tooltips: {
        mode: 'index',
        intersect: true,
        position: 'nearest',
        titleFontFamily: FONT_FAMILY,
        bodyFontFamily: FONT_FAMILY
      },
      responsive: true,
      hover: {
        mode: 'nearest',
        intersect: true
      },
      scales: {
        xAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'Días'
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: ''
          }
        }]
      }
    },
    moneda: {
      title: {
        display: true,
        fontSize: 16,
        fontFamily: FONT_FAMILY,
        text: ''
      },
      legend: {
        labels: {
          fontFamily: FONT_FAMILY
        }
      },
      elements: {
        line: {
          tension: 0.4
        }
      },
      tooltips: {
        mode: 'index',
        intersect: true,
        position: 'nearest',
        titleFontFamily: FONT_FAMILY,
        bodyFontFamily: FONT_FAMILY
      },
      responsive: true,
      hover: {
        mode: 'nearest',
        intersect: true
      },
      scales: {
        scaleLabel: {
          display: true,
          labelString: 'en millones'
        },
        xAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'Días'
          }
        }],
        yAxes: [{
          display: true,
          ticks: {
            callback: "function(value, index, values) {
                        return '$' + value;
                      }",
            stepSize: 10_000_000
          },
          scaleLabel: {
            display: true,
            labelString: ''
          }
        }]
      }
    }
  }

  scope :sucursal_dashboard, ->(codigo_sucursal) { where('registros.codigo_sucursal': codigo_sucursal).uniq }
  scope :admin_dashboard, lambda {
    includes(registros: :user).
      where(is_admin: true).
      where(registros: { fecha: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month })
  }

  accepts_nested_attributes_for :objetivos

  def init_instance_variables
    @obj_total ||= 0
    @total_prediction_percent ||= []
  end

  def admin_graph_options
    ADMIN_GRAPH_OPTIONS[tipo.to_sym][:title][:text] = nombre.capitalize
    ADMIN_GRAPH_OPTIONS[tipo.to_sym][:scales][:yAxes][0][:scaleLabel][:labelString] = nombre.capitalize

    ADMIN_GRAPH_OPTIONS[tipo.to_sym]
  end

  # def calculate_extreme_values(min = 0, max = 0)
  # end

  def variable_types
    VARIABLE_TYPES
  end

  def objetivo_by_user(user, mes = nil, anio = nil)
    mes ||= Time.zone.today.month
    anio ||= Time.zone.today.year

    objetivos.select { |o| o.user == user && o.mes == mes.to_i && o.anio == anio.to_i }.first
    # objetivos.find_by(user: user)
  end

  def calculate_current_value(user, mes = Time.zone.today.month, anio = Time.zone.today.year)
    last_record = registros_by_user_per_month(user, mes, anio)

    if last_record.nil?
      0
    else
      last_record.value
    end
  end

  def calculate_value(user, month, year)
    registros_by_user_per_month(user, month, year).sum(:value)
  end

  def graph_options
    {
      symbol: GRAPH_OPTIONS[tipo.to_sym][:symbol]
    }
  end

  def registros_by_user_per_month(user, month = nil, year = nil)
    month ||= Time.zone.today.month
    year ||= Time.zone.today.year

    registros.sort_by(&:fecha).reverse.select { |r| r.codigo_sucursal == user.codigo_sucursal.to_i && r.fecha.month == month.to_i && r.fecha.year == year.to_i }.take(1).first
    # registros.select { |r| r.codigo_sucursal == user.codigo_sucursal.to_i && r.fecha.month == month.to_i && r.fecha.year == year.to_i }
  end

  def total_goal
    @obj_total = objetivos.sum(:valor)

    {
      label: "Objetivo #{nombre.capitalize}",
      backgroundColor: 'rgba(58, 181, 64,0.5)',
      borderColor: 'rgba(58, 181, 64,0.8)',
      borderWidth: 1,
      fill: false,
      data: Array.new(Time.days_in_month(Time.zone.today.month, Time.zone.today.year), @obj_total)
    }
  end

  def current_total_value
    {
      label: 'Valor Actual Total',
      backgroundColor: 'rgba(48,84,218,0.5)',
      borderColor: 'rgba(48,84,218,0.8)',
      borderWidth: 1,
      fill: false,
      data: calculate_data_value(:addition)
    }
  end

  def total_prediction
    {
      label: "Proyección #{nombre.capitalize}",
      backgroundColor: 'rgba(60,30,112,0.5)',
      borderColor: 'rgba(60,30,112,0.8)',
      borderWidth: 1,
      fill: false,
      data: calculate_data_value(:prediction)
    }
  end

  def total_prediction_percent
    {
      label: "Porcentaje proyectado #{nombre.capitalize}",
      backgroundColor: 'rgba(230,119,24,0.5)',
      borderColor: 'rgba(230,119,24,0.8)',
      borderWidth: 1,
      fill: false,
      data: @total_prediction_percent
    }
  end

  private

  def calculate_data_value(calculator)
    total_goal if @obj_total.zero?
    total_days_in_month = Time.days_in_month(Time.zone.today.month, Time.zone.today.year)
    month_values = Array.new(total_days_in_month, 0)

    first_date_month = Time.zone.today.beginning_of_month
    hsh_registros = registros.group_by(&:fecha)
    last_value = 0
    month_values.each_index do |idx|
      c_key = first_date_month + idx

      hsh_values = send(calculator, hsh_registros[c_key], last_value, idx + 1, total_days_in_month)
      month_values[idx] = hsh_values[:day_value]
      last_value = hsh_values[:last_value]
    end

    month_values
  end

  def addition(array_values, last_value, _current_day = nil, _total_days_in_month = nil)
    day_value = if array_values.nil?
                  last_value
                else
                  array_values.sum(&:value).to_f.round(2)
                end

    { day_value: day_value, last_value: day_value }
  end

  def prediction(array_values, last_value, current_day, total_days_in_month)
    hsh_rta = {}

    if array_values.nil?
      hsh_rta[:day_value] = ((last_value / current_day) * total_days_in_month).round(2)
      hsh_rta[:last_value] = last_value
    else
      current_total_value = addition(array_values, last_value, nil, nil)[:day_value]
      hsh_rta[:day_value] = ((current_total_value / current_day) * total_days_in_month).round(2)
      hsh_rta[:last_value] = current_total_value
    end

    @total_prediction_percent << (hsh_rta[:day_value] / @obj_total).round(2) unless @obj_total.zero?
    hsh_rta
  end

  def check_variable_type
    errors.add(:tipo, I18n.t('tipo.undefined', tipos: VARIABLE_TYPES, scope: [:activerecord, :errors, :messages])) unless VARIABLE_TYPES.include?(tipo)
  end
end
