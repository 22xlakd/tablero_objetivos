class RegistrosController < ApplicationController
  load_and_authorize_resource

  # GET /registros
  # GET /registros.json
  def index
    @registros = Registro.all
  end

  # GET /registros/1
  # GET /registros/1.json
  def show; end
end
