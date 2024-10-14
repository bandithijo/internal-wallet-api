class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

    def authorize_request
      header = request.headers["Authorization"]
      token = header.split(" ").last if header
      decoded_token = JsonWebToken.decode(token)

      user_token = UserToken.find_by(token: token)
      if user_token && user_token.token_expired_at > Time.current
        @current_user = User.find(decoded_token[:user_id]) if decoded_token
      else
        render json: { errors: "Unauthorized" }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: "Unauthorized" }, status: :unauthorized
    end
end
