FactoryBot.define do
  factory :debit_transaction do
    type { "DebitTransaction" }
    source_wallet { nil }
    target_wallet { nil }
    amount { "9.99" }
  end
end
