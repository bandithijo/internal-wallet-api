FactoryBot.define do
  factory :user_token do
    association :user, factory: :user
    token { JsonWebToken.encode({ user_id: rand(100..1000) }) }
    token_expired_at { Time.now + 2.hours }
  end
end
