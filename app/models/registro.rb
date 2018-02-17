class Registro < ActiveRecord::Base
  has_one :user, foreign_key: :codigo_sucursal
  belongs_to :variable
end
