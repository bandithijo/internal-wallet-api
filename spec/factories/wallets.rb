FactoryBot.define do
  factory :wallet do
    association :walletable, factory: [ :user, :team, :stock ].sample
    balance { 0 }

    trait :without_walletable do
      walletable { nil }
    end
  end
end
