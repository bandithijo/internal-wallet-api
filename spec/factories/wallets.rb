FactoryBot.define do
  factory :wallet do
    association :walletable, factory: [ :user, :team, :stock ].sample
    balance { 9.99 }

    trait :without_walletable do
      walletable { nil }
    end
  end
end
