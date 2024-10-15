class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.find_by(email: session_params[:email])

    if user && user.authenticate(session_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      token_expired_at = 24.hours.from_now
      user_token = UserToken.create!(user: user, token: token, token_expired_at: token_expired_at)

      data = {
        message: "Login successful",
        token: token,
        token_expired_at: {
          format_datetime: token_expired_at,
          format_integer: token_expired_at.to_i
        }
      }

      api(data, :created)
    else
      api({ error: "Invalid email or password" }, :unauthorized)
    end
  end

  def destroy
    token = request.headers["Authorization"]&.split(" ")&.last
    user_token = UserToken.find_by(token: token)

    if user_token
      user_token.destroy

      api({ message: "Logout successful" }, :no_content)
    else
      api({ error: "Invalid token" }, :unauthorized)
    end
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end
end
