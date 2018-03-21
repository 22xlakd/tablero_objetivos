require 'csv'

class Custom::Importer::FileReaderCSV
  def initialize(file = nil)
    @file = file
  end

  def read
    raise 'El archivo no es del día de hoy' if @file.mtime.to_date != Date.today

    CSV.read(@file.path)
  end
end
