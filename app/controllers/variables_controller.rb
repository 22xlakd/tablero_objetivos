class VariablesController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource only: :show

  # GET /variables
  # GET /variables.json
  def index
    @variables = Variable.all
  end

  # GET /variables/1
  # GET /variables/1.json
  def show
    @variable = Variable.includes(objetivos: :user).find(params[:id])
    authorize! :show, @variable

    @hs_obj_by_usr = @variable.objetivos.group_by(&:user)
  end

  # GET /variables/new
  def new; end

  # GET /variables/1/edit
  def edit
    @variable.objetivos.build if @variable.objetivos.empty?
    @hs_obj_by_usr = @variable.objetivos.group_by(&:user)
  end

  def tablero_objetivos
    @user = nil
    mes = nil
    anio = nil

    if params[:codigo_sucursal]
      @user = User.find_by(codigo_sucursal: params[:codigo_sucursal])

      unless params[:date].nil?
        mes = params[:date][:mes]
        anio = params[:date][:anio]
      end
    else
      @user = current_user
    end

    @tablero = Variable.includes(:registros, :objetivos).sucursal_dashboard(@user.codigo_sucursal)

    respond_to do |format|
      if @tablero.count > 0
        format.html { render :tablero_objetivos, locals: { mes: mes, anio: anio } }
        format.json { render :tablero_objetivos, status: :ok }
      else
        format.html { render :tablero_objetivos, notice: I18n.t(:no_variables_found) }
        format.json { render json: I18n.t(:no_variables_found), status: :unprocessable_entity }
      end
    end
  end

  def tablero_admin
    @variables_admin = Variable.admin_dashboard
    @dashboard_data = current_user.build_admin_dashboard(@variables_admin)

    respond_to do |format|
      if @variables_admin.count > 0
        format.html { render :tablero_admin }
        format.json { render :tablero_admin, status: :ok }
      else
        format.html { render :tablero_admin, notice: I18n.t(:no_variables_found) }
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
    @hs_obj_by_usr = @variable.objetivos.group_by(&:user)

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
    params.require(:variable).permit(:nombre, :tipo, :puntaje, :inverse, objetivos_attributes: [:id, :proyeccion_mensual, :porcentaje_proyectado, :valor, :mes, :anio, :user_id, :variable_id])
  end
end
