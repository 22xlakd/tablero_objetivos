class Objetivo < ActiveRecord::Base
  belongs_to :variable
  belongs_to :user

  validates :variable, presence: true
  validates :user, presence: true
  validates :proyeccion_mensual, numericality: { greater_than: 0 }
  validates :porcentaje_proyectado, numericality: { greater_than: 0 }
  validates :user, uniqueness: { scope: :variable }

  def cumplido?(current_value = 0)
    current_value > valor
  end
end
