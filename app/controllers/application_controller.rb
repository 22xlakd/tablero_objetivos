class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :first_name, :last_name, :password, :password_confirmation, :email) }
  end

  def home
    if current_user.include_role?('admin')
      redirect_to controller: 'users', action: 'ranking_usuarios'
    else
      redirect_to controller: 'variables', action: 'tablero_objetivos'
    end
  end

  rescue_from CanCan::AccessDenied do
    flash[:error] = I18n.t(:unauthorized)
    redirect_to authenticated_root_path
  end
end
