FactoryBot.define do
  factory :transaction do
    type { "" }
    source_wallet { nil }
    target_wallet { nil }
    amount { "9.99" }
  end
end
