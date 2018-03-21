class Custom::Importer::VariableImporter
  def import(data = nil)
    raise(StandardError, 'No se puede leer el archivo de datos') if data.nil?

    var_with_problems = []
    # NOTE QUITAMOS ENCABEZADOS
    data.shift
    data.each do |c_row|
      c_variable = Variable.find_by(id: c_row[0])
      c_variable = Variable.new if c_variable.nil?

      c_variable.nombre = c_row[1].tr('_', ' ').capitalize
      c_variable.tipo = if c_row[2] == 'integer'
                          c_variable.variable_types[1]
                        else
                          c_variable.variable_types[2]
                        end
      c_variable.puntaje = 0

      var_with_problems << c_variable.errors.full_messages.join(',') unless c_variable.save
    end

    var_with_problems
  end
end
