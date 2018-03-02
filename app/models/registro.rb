class Registro < ActiveRecord::Base
  belongs_to :user, foreign_key: :codigo_sucursal, primary_key: :codigo_sucursal
  belongs_to :variable

  validates :fecha, presence: true
  validates :value, presence: true
  validates :variable, presence: true
  validates :user, presence: true
end
