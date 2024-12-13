module AuthHelpers
  def login_user(user)
    token = JsonWebToken.jwt_encode(user_id: user.id)
    session[:token] = token
    controller.instance_variable_set(:@current_user, user)
  end

  def login_user_request(user)
    token = JsonWebToken.jwt_encode(user_id: user.id)
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ token: token })
  end
end