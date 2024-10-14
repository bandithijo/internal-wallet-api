module JsonWebToken
  SECRET_KEY = Rails.application.credentials.jwt_secret

  def self.encode(payload, expired_at = 24.hours.from_now)
    payload[:expired_at] = expired_at.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
