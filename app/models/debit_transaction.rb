class DebitTransaction < Transaction
  # Callbacks
  before_create :adjust_source_wallet_balance

  private

    def adjust_source_wallet_balance
      if source_wallet.balance >= amount
        source_wallet.update!(balance: source_wallet.balance - amount)
      else
        errors.add(:base, "Insufficient funds")
        throw(:abort)
      end
    end
end
