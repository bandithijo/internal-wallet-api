FactoryBot.define do
  factory :credit_transaction do
    type { "CreditTransaction" }
    source_wallet { nil }
    target_wallet { nil }
    amount { "9.99" }
  end
end
