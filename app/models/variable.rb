class Variable < ActiveRecord::Base
  validates :nombre, presence: true
  validates :puntaje, numericality: { greater_than_or_equal_to: 0 }
  validate :check_variable_type

  has_many :registros
  has_many :objetivos

  VARIABLE_TYPES = %w(porcentaje entero moneda)
  GRAPH_OPTIONS = { porcentaje: { symbol: '%' }, entero: { symbol: '' }, moneda: { symbol: '$' } }
  ADMIN_GRAPH_OPTIONS = {
    porcentaje: {},
    entero: {},
    moneda: {
      title: {
        display: true,
        fontSize: 16,
        fontFamily: "'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'",
        text: ''
      },
      legend: {
        labels: {
          fontFamily: "'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'"
        }
      },
      elements: {
        line: {
          tension: 0.8
        }
      },
      tooltips: {
        mode: 'index',
        intersect: true,
        position: 'nearest',
        titleFontFamily: "'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'",
        bodyFontFamily: "'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'"
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
          ticks: {
            callback: "function(value, index, values) {
                        return '$' + value / 1000000 ;
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

  scope :sucursal_dashboard, ->(codigo_sucursal) { joins(:registros).where('registros.codigo_sucursal': codigo_sucursal).uniq }
  scope :admin_dashboard, lambda {
    includes(registros: :user).
      where(is_admin: true).
      where(registros: { fecha: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month })
  }

  # DESPUES DEL SCOPE, PARA SACAR LOS TOTALES (a ES EL SCOPE) : h = a.first.registros.group_by{ |r| r.codigo_sucursal}
  # h.keys.map{|k| h[k].sum(&:value).to_f} -> SUMA LOS VALORES DE LOS REGISTROS POR USUARIO
  # h = a.first.registros.group_by{ |r| r.codigo_sucursal} -> agrupa por usuarios
  # h.keys.map{|k| puts h[k].sum(&:value) } -> suma registros x usuario

  accepts_nested_attributes_for :objetivos

  after_find do
    @obj_total = 0
    @total_prediction = 0
  end

  def admin_graph_options
    ADMIN_GRAPH_OPTIONS[tipo.to_sym][:title][:text] = nombre.capitalize
    ADMIN_GRAPH_OPTIONS[tipo.to_sym][:scales][:yAxes][0][:scaleLabel][:labelString] = nombre.capitalize

    ADMIN_GRAPH_OPTIONS[tipo.to_sym]
  end

  def variable_types
    VARIABLE_TYPES
  end

  def objetivo_by_user(user)
    objetivos.select { |o| o.user == user }.first
    # objetivos.find_by(user: user)
  end

  def calculate_current_value(user)
    registros_by_user_per_month(user).sum(&:value)
  end

  def calculate_value(user, month, year)
    registros_by_user_per_month(user, month, year).sum(:value)
  end

  def graph_options
    {
      symbol: GRAPH_OPTIONS[tipo.to_sym][:symbol]
    }
  end

  def registros_by_user_per_month(user, month = Time.zone.today.month, year = Time.zone.today.year)
    registros.select { |r| r.codigo_sucursal == user.codigo_sucursal.to_i && r.fecha.month == month.to_i && r.fecha.year == year.to_i }
    # registros.where(codigo_sucursal: user.codigo_sucursal).where('extract(month from fecha) = ?', month).where('extract(year from fecha) = ?', year)
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
      data: prediction_percent
    }
  end

  private

  def calculate_data_value(calculator)
    total_goal if @obj_total.zero?
    month_values = Array.new(Time.days_in_month(Time.zone.today.month, Time.zone.today.year), 0)

    first_date_month = Time.zone.today.beginning_of_month
    hsh_registros = registros.group_by(&:fecha)
    last_value = 0
    month_values.each_index do |idx|
      c_key = first_date_month + idx
      if hsh_registros[c_key].nil?
        month_values[idx] = last_value
      else
        month_values[idx] = last_value + send(calculator, hsh_registros[c_key], c_key.day)
        last_value = month_values[idx]
      end
    end

    month_values
  end

  def addition(array_values, _current_day = nil)
    array_values.sum(&:value).to_f.round(2)
  end

  def prediction(array_values, current_day)
    c_prediction = array_values.sum { |record| (record.value / current_day) * Time.days_in_month(Time.zone.today.month, Time.zone.today.year) }.to_f.round(2)
    @total_prediction += c_prediction

    c_prediction
  end

  def prediction_percent
    prediction_percent = (@total_prediction / @obj_total).round(2) unless @obj_total.zero?

    Array.new(Time.days_in_month(Time.zone.today.month, Time.zone.today.year), prediction_percent)
  end

  def check_variable_type
    errors.add(:tipo, I18n.t('tipo.undefined', tipos: VARIABLE_TYPES, scope: [:activerecord, :errors, :messages])) unless VARIABLE_TYPES.include?(tipo)
  end
end
