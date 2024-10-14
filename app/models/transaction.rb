class Transaction < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_source_and_target_wallets

  # Class Methods
  def self.perform_transaction(source_wallet: nil, target_wallet: nil, amount:, user:)
    ActiveRecord::Base.transaction do
      if source_wallet
        raise "Insufficient funds" if source_wallet.balance < amount

        source_wallet.update!(balance: source_wallet.balance - amount)
      end

      if target_wallet
        target_wallet.update!(balance: target_wallet.balance + amount)
      end

      create!(source_wallet: source_wallet, target_wallet: target_wallet, amount: amount, user: user)
    end
  end

  def self.perform_credit(target_wallet, amount, user)
    CreditTransaction.perform_transaction(target_wallet: target_wallet, amount: amount, user: user)
  end

  def self.perform_debit(source_wallet, amount, user)
    DebitTransaction.perform_transaction(source_wallet: source_wallet, amount: amount, user: user)
  end

  # Scopes
  scope :type, ->(type) {
    case type
    when 'Debit', 'debit'
      where(type: 'DebitTransaction')
    when 'Credit', 'credit'
      where(type: 'CreditTransaction')
    else
      where(type: nil)
    end
  }
  scope :_order, ->(order) {
    case order
    when 'desc'
      reorder(created_at: :desc)
    when 'asc'
      reorder(created_at: :asc)
    else
      reorder(created_at: :desc)
    end
  }

  private

    def validate_source_and_target_wallets
       if source_wallet.nil? && target_wallet.nil?
        errors.add(:base, "Transaction must have a source or target wallet")
       end
    end
end
