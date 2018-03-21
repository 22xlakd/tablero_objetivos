module UsersHelper
  def display_user_selector(variable, condition)
    users = if condition == :exclude
              User.sucursal.where.not(id: variable.objetivos.map(&:user_id))
            else
              User.sucursal
            end

    if users.empty?
      ''
    else
      select('usuario', 'id', users.collect { |u| [u.nombre.capitalize, u.id] }, { include_blank: false }, class: 'form-control input-height')
    end
  end
end
