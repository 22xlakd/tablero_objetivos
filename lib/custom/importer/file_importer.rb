require 'net/ftp'

class Custom::Importer::FileImporter
  def initialize
    counter = 1
    begin
      port = nil
      port = Rails.configuration.x.importer.connection_data[:port] unless Rails.configuration.x.importer.connection_data[:port] == '21'
      @ftp = Net::FTP.new
      @ftp.connect(Rails.configuration.x.importer.connection_data[:host], port)
      @ftp.passive = Rails.configuration.x.importer.connection_data[:passive]
      @ftp.login(Rails.configuration.x.importer.connection_data[:user], Rails.configuration.x.importer.connection_data[:password])
    rescue StandardError => e
      counter += 1

      if counter <= 3
        retry
      else
        raise "Attempt to connect #{counter - 1} times - #{e.message}"
      end
    end
  end

  def import(path = nil, file = nil)
    begin
      @ftp.chdir(path)
      @ftp.getbinaryfile(file, Rails.configuration.x.importer.destination_path + file)
    rescue StandardError => e
      raise e.message
    end

    source_file = File.new(Rails.configuration.x.importer.destination_path + file)
    if !source_file.readlines.empty?
      source_file.rewind
      return source_file
    else
      raise 'El archivo fuente está vacío'
    end
  end
end
