class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: :sign_in
  before_action :load_roles, only: [:create, :update, :edit, :new]
  before_action :extract_roles_from_params, only: [:create, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new; end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json

  def ranking_usuarios
    @users = User.sucursal
    @points = {}

    @users.each do |c_user|
      @points[c_user.id] = [c_user.current_month_points, c_user.year_points]
    end

    @users = @users.sort_by(&:current_month_points).reverse
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        set_roles
        format.html { redirect_to @user, notice: I18n.t(:user_created) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(user_params)
        set_roles
        format.html { redirect_to @user, notice: I18n.t(:user_updated) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.objetivos.map(&:destroy)
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: I18n.t(:user_destroyed) }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:nombre, :apellido, :email, :password, :password_confirmation, :codigo_sucursal, :role_ids)
  end

  def load_roles
    @roles = Role.all
  end

  def extract_roles_from_params
    @roles_ids = params[:user].delete('role_ids') if params[:user]
  end

  def set_roles
    @user.roles = Role.where(id: @roles_ids) if @roles_ids
  end
end
