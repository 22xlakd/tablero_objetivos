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

  def calculate_current_month_points
    total_month_points = 0
    objetivos.each do |c_objetivo|
      total_month_points += c_objetivo.variable.puntaje if c_objetivo.cumplido?
    end

    total_month_points
  end

  def best_objective
    best_obj = objetivos.min_by(&:current_distance)

    if best_obj.nil?
      {}
    else
      { name: best_obj.variable.nombre, value: best_obj.current_distance.abs, type: best_obj.variable.tipo }
    end
  end

  def worst_objective
    worst_obj = objetivos.max_by(&:current_distance)

    if worst_obj.nil?
      {}
    else
      { name: worst_obj.variable.nombre, value: worst_obj.current_distance.abs, type: worst_obj.variable.tipo }
    end
  end

  def calculate_year_points(year = Time.zone.today.year)
    total_year_points = 0
    objetivos.each do |c_objetivo|
      total_year_points += c_objetivo.points_per_year(year)
    end

    total_year_points
  end
end
