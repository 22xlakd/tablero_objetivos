class Objetivo < ActiveRecord::Base
  belongs_to :variable
  belongs_to :user

  validates :variable, presence: true
  validates :user, presence: true
  validates :mes, numericality: { greater_than: 0, less_than_or_equal_to: 12 }
  validates :anio, numericality: { greater_than_or_equal_to: Time.zone.today.year }
  # validates :proyeccion_mensual, numericality: { greater_than: 0 }
  # validates :porcentaje_proyectado, numericality: { greater_than: 0 }
  validates :user, uniqueness: { scope: [:variable, :mes, :anio] }
  validates :variable, uniqueness: { scope: [:user, :mes, :anio] }
  validates :mes, uniqueness: { scope: [:user, :variable, :anio] }
  validates :anio, uniqueness: { scope: [:user, :variable, :mes] }

  def cumplido?(current_value)
    if variable.inverse
      current_value <= valor
    else
      current_value >= valor
    end
  end

  def fue_cumplido?(month, year)
    variable.calculate_value(user, month, year) > valor
  end

  def points_per_year(monthly_values)
    total_points = 0

    monthly_values.each do |c_value|
      total_points += variable.puntaje if cumplido?(c_value)
    end

    total_points
  end

  def current_distance(current_value)
    if variable.inverse
      current_value - valor
    else
      valor - current_value
    end
  end
end
