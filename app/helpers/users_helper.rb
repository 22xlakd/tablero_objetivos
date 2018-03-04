module UsersHelper
  def display_user_selector
    select('usuario', 'id', User.sucursal.collect { |u| ["#{u.nombre.capitalize} #{u.apellido.capitalize}", u.id] }, { include_blank: false }, class: 'form-control input-height', onchange: 'hideObjetivosForm();')
  end
end
