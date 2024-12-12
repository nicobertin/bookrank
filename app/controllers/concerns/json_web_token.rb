require "jwt"

module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def jwt_encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    raise JWT::DecodeError, "Token has expired"
  rescue JWT::DecodeError => e
    raise JWT::DecodeError, "Token is invalid: #{e.message}"
  end
end