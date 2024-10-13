class Transaction < ApplicationRecord
  # Associations
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_source_and_target_wallets

  # Class Methods
  def self.perform_transaction(source_wallet: nil, target_wallet: nil, amount:)
    ActiveRecord::Base.transaction do
      if source_wallet
        raise "Insufficient funds" if source_wallet.balance < amount

        source_wallet.update!(balance: source_wallet.balance - amount)
      end

      if target_wallet
        target_wallet.update!(balance: target_wallet.balance + amount)
      end

      create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: amount)
    end
  end

  private

    def validate_source_and_target_wallets
       if source_wallet.nil? && target_wallet.nil?
        errors.add(:base, "Transaction must have a source or target wallet")
       end
    end
end
