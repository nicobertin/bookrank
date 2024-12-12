class AuthenticationController < ApplicationController
  include JsonWebToken

  before_action :normalize_email_param, only: [:login, :register]

  def register
    user = User.new(user_params)
    if user.save
      complete_login(user)
    else
      flash[:alert] = user.errors.full_messages.join(', ')
      render users_register_path
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      complete_login(user)
    else
      flash[:alert] = "Incorrect email or password."
      render users_login_path
    end
  end

  def logout
    session.delete(:token)
    redirect_to users_login_path, notice: "Logged out successfully."
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def normalize_email_param
    params[:email].downcase! if params[:email].present?
  end

  def complete_login(user)
    token = jwt_encode({ user_id: user.id })
    session[:token] = token

    attempted_url = session.delete(:attempted_url)
    redirect_to attempted_url || root_path, notice: "Login successful."
  end
end