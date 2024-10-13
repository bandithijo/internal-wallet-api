class Wallet < ApplicationRecord
  # Associations
  belongs_to :walletable, polymorphic: true

  has_many :source_transactions, class_name: "DebitTransaction", foreign_key: "source_wallet_id"
  has_many :target_transactions, class_name: "CreditTransaction", foreign_key: "target_wallet_id"

  # Validations
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Instance Methods
  def update_balance!
    self.balance = target_transactions.sum(:amount) - source_transactions.sum(:amount)
    save!
  end
end
