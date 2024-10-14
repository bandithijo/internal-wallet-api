class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.find_by(email: session_params[:email])

    if user && user.authenticate(session_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      token_expired_at = 24.hours.from_now
      user_token = UserToken.create!(user: user, token: token, token_expired_at: token_expired_at)

      render json: {
        message: "Login successful",
        token: token,
        token_expired_at: {
          format_datetime: token_expired_at,
          format_integer: token_expired_at.to_i
        }
      }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    token = request.headers["Authorization"]&.split(" ")&.last
    user_token = UserToken.find_by(token: token)

    if user_token
      user_token.destroy

      render json: { message: "Logout successful" }, status: :no_content
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
