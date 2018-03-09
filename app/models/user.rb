class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :codigo_sucursal, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  has_and_belongs_to_many :roles
  has_many :registros, foreign_key: :codigo_sucursal, primary_key: :codigo_sucursal
  has_many :objetivos

  scope :sucursal, -> { includes(:roles).where('roles.name' => 'sucursal') }

  def include_role?(role = nil)
    roles.include?(Role.find_by(name: role))
  end
end
