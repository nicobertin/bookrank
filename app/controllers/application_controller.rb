class ApplicationController < ActionController::Base
  include JsonWebToken

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_user

  private

  def set_current_user
    token = session[:token]
    @current_user = if token.present?
                      decoded = jwt_decode(token)
                      User.find_by(id: decoded[:user_id])
                    end
  rescue JWT::DecodeError
    @current_user = nil
    session[:token] = nil
  end

  def authenticate_user!
    unless @current_user
      session[:attempted_url] = request.fullpath
      redirect_to users_login_path, alert: "You must be logged in to access this page."
    end
  end
end