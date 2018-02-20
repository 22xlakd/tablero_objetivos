class Variable < ActiveRecord::Base
  validates :nombre, :valor_objetivo, presence: true
  validates :puntaje, numericality: { greater_than: 0 }
  validate :check_variable_type

  has_many :registros

  VARIABLE_TYPES = %w(porcentaje entero moneda)

  scope :sucursal_dashboard, ->(codigo_sucursal) { joins(:registros).where('registros.codigo_sucursal': codigo_sucursal) }
  scope :admin_dashboard, -> { where(nombre: ['Cantidad de clientes']) }

  def variable_types
    VARIABLE_TYPES
  end

  def registros_by_user(user)
    registros.where(codigo_sucursal: user.codigo_sucursal)
  end

  private

  def check_variable_type
    errors.add(:tipo, I18n.t('tipo.undefined', tipos: VARIABLE_TYPES, scope: [:activerecord, :errors, :messages])) unless VARIABLE_TYPES.include?(tipo)
  end
end
