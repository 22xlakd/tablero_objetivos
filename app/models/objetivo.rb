class Objetivo < ActiveRecord::Base
  belongs_to :variable
  belongs_to :user

  validates :variable, presence: true
  validates :proyeccion_mensual, numericality: { greater_than: 0 }


end
