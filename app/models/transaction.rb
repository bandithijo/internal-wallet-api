class Transaction < ApplicationRecord
  # Associations
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_source_and_target_wallets

  private

    def validate_source_and_target_wallets
      errors.add(:base, "Transaction must have a source or target wallet") if source_wallet.nil? || target_wallet.nil?
    end
end
