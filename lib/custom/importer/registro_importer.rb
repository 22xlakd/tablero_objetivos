class Custom::Importer::RegistroImporter
  def import(data = nil)
    raise(StandardError, 'No se puede leer el archivo de datos') if data.nil?

    registro_with_problems = []

    # NOTE QUITAMOS ENCABEZADOS
    data.shift
    data.each do |c_row|
      c_variable = Variable.find_by(codigo_variable: c_row[2])
      next if c_variable.nil?

      c_registro = Registro.where(fecha: Date.parse(c_row[0]), codigo_sucursal: c_row[1], variable_id: c_variable.id).first

      c_registro = Registro.new(fecha: c_row[0], value: c_row[3]) if c_registro.nil?

      c_user = User.find_by(codigo_sucursal: c_row[1])

      if c_variable.nil? || c_user.nil?
        registro_with_problems << "Registro no creado, variable nil? #{c_variable.nil?} usuario nil? #{c_user.nil?}"
        next
      end

      c_registro.user = c_user
      c_registro.variable = c_variable

      registro_with_problems << c_registro.errors.full_messages.join(',') unless c_registro.save
    end

    registro_with_problems
  end
end
