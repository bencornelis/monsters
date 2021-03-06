class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:username, :email, :password, :password_confirmation)
    end
  end

  private

  # override devise helper to handle AJAX
  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "You must be logged in to do that."
      respond_to do |format|
        format.html { redirect_to login_path }
        format.js   { render :js => "window.location = '#{login_path}'" }
      end
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def reload_user_associations!
    return unless user_signed_in?
    @current_user = User.includes(:followees, :shared_comments, :badges_to_give)
                        .find(current_user.id)
  end
end
