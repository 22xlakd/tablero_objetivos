desc 'Importa variables del sistema a partir de un archivo'
task :import_variables, [:dir, :file] => :environment do |t, args|
  args.with_defaults(dir: '/ftp/estadisticas/', file: 'variables.csv')

  logger = Logger.new("#{Rails.root}/log/rake_import_variables.log", 'daily')
  logger.info("Iniciando proceso importación.....#{Time.now}..")

  begin
    if Rails.configuration.x.importer.source_file == 'ftp'
      file_importer = Custom::Importer::FileImporter.new
      file = file_importer.import('estadisticas/', 'variables.csv')
    else
      path_file = args.dir.to_s + args.file.to_s
      file = File.new(path_file)
    end

    variable_importer = Custom::Importer::VariableImporter.new
    file_reader = Custom::Importer::FileReaderCSV.new(file)
    file_data = file_reader.read

    rta_import_variable = variable_importer.import(file_data)
    logger.debug("Respuesta importación:.........#{rta_import_variable}...")
  rescue StandardError => e
    logger.info("El proceso de importación falló: #{e.message}")
  end

  logger.info("...........Finalizando proceso........#{Time.now}")
  logger.close
end

desc 'Importa registros de variables a partir de un archivo'
task :import_registros, [:dir, :file] => :environment do |t, args|
  args.with_defaults(dir: '/ftp/estadisticas/', file: 'datosdevariables.csv')

  logger = Logger.new("#{Rails.root}/log/rake_import_registros.log", 'daily')
  logger.info("Iniciando proceso importación.....#{Time.now}..")

  # begin
  if Rails.configuration.x.importer.source_file == 'ftp'
    file_importer = Custom::Importer::FileImporter.new
    file = file_importer.import('estadisticas/', 'datosdevariables.csv')
  else
    path_file = args.dir.to_s + args.file.to_s
    file = File.new(path_file)
  end

  registro_importer = Custom::Importer::RegistroImporter.new
  file_reader = Custom::Importer::FileReaderCSV.new(file)
  file_data = file_reader.read

  rta_import_registro = registro_importer.import(file_data)
  logger.debug("Respuesta importación:.........#{rta_import_registro}...")
  # rescue StandardError => e
  #  logger.info("El proceso de importación falló: #{e.message}")
  # end
  # COMIENZA CALCULO PUNTOS USUARIOS

  users = User.sucursal.includes(:registros)
  users.each do |c_user|
    c_user.current_month_points = c_user.calculate_current_month_points
    c_user.year_points = c_user.calculate_year_points

    if c_user.save
      logger.info("Guardando usuario.....: #{c_user.nombre}")
    else
      logger.info("Problemas guardando usuario.....: #{c_user.nombre} - Error ocurrido: #{c_user.errors}")
    end
  end

  logger.info("...........Finalizando proceso........#{Time.now}")
  logger.close
end
