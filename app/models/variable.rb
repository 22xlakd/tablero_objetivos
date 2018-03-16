class Variable < ActiveRecord::Base
  validates :nombre, presence: true
  validates :puntaje, numericality: { greater_than: 0 }
  validate :check_variable_type

  has_many :registros
  has_many :objetivos

  VARIABLE_TYPES = %w(porcentaje entero moneda)
  GRAPH_OPTIONS = { porcentaje: { symbol: '%' }, entero: { symbol: '' }, moneda: { symbol: '' } }

  scope :sucursal_dashboard, ->(codigo_sucursal) { joins(:registros).where('registros.codigo_sucursal': codigo_sucursal).uniq }
  scope :admin_dashboard, -> { where(nombre: ['Cantidad de clientes']) }

  accepts_nested_attributes_for :objetivos

  def variable_types
    VARIABLE_TYPES
  end

  def objetivo_by_user(user)
    objetivos.find_by(user: user)
  end

  def calculate_current_value(user)
    registros_by_user_per_month(user).sum(:value)
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
    registros.where(codigo_sucursal: user.codigo_sucursal).where('extract(month from fecha) = ?', month).where('extract(year from fecha) = ?', year)
  end

  private

  def check_variable_type
    errors.add(:tipo, I18n.t('tipo.undefined', tipos: VARIABLE_TYPES, scope: [:activerecord, :errors, :messages])) unless VARIABLE_TYPES.include?(tipo)
  end
end
