class Wallet < ApplicationRecord
  # Associations
  belongs_to :walletable, polymorphic: true

  has_many :source_transactions, class_name: "Transaction", foreign_key: "source_wallet_id"
  has_many :target_transactions, class_name: "Transaction", foreign_key: "target_wallet_id"

  # Validations
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
