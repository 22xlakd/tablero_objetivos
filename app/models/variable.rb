class Variable < ActiveRecord::Base
  validates :nombre, presence: true
  validates :puntaje, numericality: { greater_than_or_equal_to: 0 }
  validate :check_variable_type

  has_many :registros
  has_many :objetivos

  VARIABLE_TYPES = %w(porcentaje entero moneda)
  GRAPH_OPTIONS = { porcentaje: { symbol: '%' }, entero: { symbol: '' }, moneda: { symbol: '$' } }

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

  def average_goal
    {
      label: "Objetivo #{nombre.capitalize}",
      backgroundColor: 'rgba(58, 181, 64,0.5)',
      borderColor: 'rgba(58, 181, 64,0.8)',
      borderWidth: 1,
      fill: false,
      data: Array.new(Time.days_in_month(Time.zone.today.month, Time.zone.today.year), objetivos.average)
    }
  end

  def current_average_value
    {
      label: 'Valor Actual Promedio',
      backgroundColor: 'rgba(220,33,27,0.5)',
      borderColor: 'rgba(220,33,27,0.8)',
      borderWidth: 1,
      fill: false,
      data: calculate_average_value
    }
  end

  private

  def calculate_average_value
    month_values = Array.new(Time.days_in_month(Time.zone.today.month, Time.zone.today.year), 0)

    hsh_registros = registros.group_by(&:fecha)
    hsh_registros.each_key do |k|
      month_values
    end
  end

  def check_variable_type
    errors.add(:tipo, I18n.t('tipo.undefined', tipos: VARIABLE_TYPES, scope: [:activerecord, :errors, :messages])) unless VARIABLE_TYPES.include?(tipo)
  end
end
