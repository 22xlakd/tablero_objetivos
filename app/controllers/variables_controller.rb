class VariablesController < ApplicationController
  load_and_authorize_resource

  # GET /variables
  # GET /variables.json
  def index
    @variables = Variable.all
  end

  # GET /variables/1
  # GET /variables/1.json
  def show; end

  # GET /variables/new
  def new; end

  # GET /variables/1/edit
  def edit; end

  def tablero_objetivos
    @tablero = if current_user.roles.select { |r| r.name == 'admin' }.count > 0
                 Variable.admin_dashboard
               else
                 Variable.where(nombre: ['Cantidad de clientes', 'Ventas totales', 'Efectividad reparto folleto', 'Cantidad de ventas'])
               end

    respond_to do |format|
      if @tablero.count > 0
        format.html { render :tablero_objetivos, tablero: @tablero }
        format.json { render :tablero_objetivos, status: :ok, tablero: @tablero }
      else
        format.html { render :tablero_objetivos, notice: I18n.t(:no_variables_found) }
        format.json { render json: I18n.t(:no_variables_found), status: :unprocessable_entity }
      end
    end
  end

  # POST /variables
  # POST /variables.json
  def create
    @variable = Variable.new(variable_params)

    respond_to do |format|
      if @variable.save
        format.html { redirect_to @variable, notice: I18n.t(:variable_created) }
        format.json { render :show, status: :created, location: @variable }
      else
        format.html { render :new }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variables/1
  # PATCH/PUT /variables/1.json
  def update
    respond_to do |format|
      if @variable.update(variable_params)
        format.html { redirect_to @variable, notice: I18n.t(:variable_updated) }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1
  # DELETE /variables/1.json
  def destroy
    @variable.destroy
    respond_to do |format|
      format.html { redirect_to variables_url, notice: I18n.t(:variable_destroyed) }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def variable_params
    params.require(:variable).permit(:nombre, :tipo, :proyeccion_mensual, :porcentaje_proyectado, :valor_objetivo, :puntaje)
  end
end
