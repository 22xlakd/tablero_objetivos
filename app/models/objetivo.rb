class Objetivo < ActiveRecord::Base
  belongs_to :variable
  belongs_to :user

  validates :variable, presence: true
  validates :user, presence: true
  # validates :proyeccion_mensual, numericality: { greater_than: 0 }
  # validates :porcentaje_proyectado, numericality: { greater_than: 0 }
  validates :user, uniqueness: { scope: :variable }

  def cumplido?
    variable.calculate_current_value(user) > valor
  end

  def fue_cumplido?(month, year)
    variable.calculate_value(user, month, year) > valor
  end

  def points_per_year(year)
    total_points = 0

    (1..12).each do |i|
      total_points += variable.puntaje if fue_cumplido?(i, year)
    end

    total_points
  end

  def current_distance
    valor - variable.calculate_current_value(user)
  end
end
