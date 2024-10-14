module RequestSpecHelper
  def user_token_generator(user)
    token = JsonWebToken.encode(user_id: user.id)
    FactoryBot.create(:user_token, user: user, token: token)
    token
  end

  def generate_user_token_expired_at(user)
    JsonWebToken.encode({ user_id: user.id, expired_at: Time.current.to_i - 10 })
  end

  def user_valid_headers
    {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{generate_user_token_expired_at(user)}"
    }
  end

  def without_auth_headers
    {
      'Content-Type': 'application/json'
    }
  end
end
