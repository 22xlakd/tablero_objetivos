class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :codigo_sucursal, presence: true
  validates :nombre, presence: true
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
      total_month_points += c_objetivo.variable.puntaje if c_objetivo.cumplido?(calculate_current_value(c_objetivo.variable.id))
    end

    total_month_points
  end

  def best_objective
    best_obj = objetivos.min_by do |o|
      o.current_distance(calculate_current_value(o.variable.id))
    end

    if best_obj.nil?
      {}
    else
      { name: best_obj.variable.nombre, value: calculate_current_value(best_obj.variable.id).abs, type: best_obj.variable.tipo }
    end
  end

  def worst_objective
    worst_obj = objetivos.max_by do |o|
      o.current_distance(calculate_current_value(o.variable.id))
    end

    if worst_obj.nil?
      {}
    else
      { name: worst_obj.variable.nombre, value: calculate_current_value(worst_obj.variable.id).abs, type: worst_obj.variable.tipo }
    end
  end

  def calculate_year_points(year = Time.zone.today.year)
    total_year_points = 0

    objetivos.each do |c_objetivo|
      monthly_values = calculate_monthly_values(year, c_objetivo.variable.id)
      total_year_points += c_objetivo.points_per_year(monthly_values)
    end

    total_year_points
  end

  def calculate_current_value(variable_id)
    registros.select { |r| r.variable_id == variable_id && r.fecha.month == Time.zone.today.month && r.fecha.year == Time.zone.today.year }.sum(&:value)
  end

  def calculate_monthly_values(year, variable_id)
    values = []

    1.upto(12) do |idx|
      values.push(registros.select { |r| r.variable_id == variable_id && r.fecha.month == idx && r.fecha.year == year.to_i }.sum(&:value))
    end

    values
  end

  def build_admin_dashboard(variables)
    dashboard_data = []
    variables.each do |c_variable|
      variable_data = {}
      variable_data[:labels] = (1..Time.days_in_month(Time.zone.today.month, Time.zone.today.year)).to_a
      variable_data[:datasets] = [c_variable.average_goal, c_variable.current_average_value, c_variable.average_prediction, c_variable.average_prediction_percent]

      dashboard_data.push(variable_data)
    end

    dashboard_data
  end
end
