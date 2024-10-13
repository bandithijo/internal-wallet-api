class CreditTransaction < Transaction
  # Callbacks
  before_create :adjust_target_wallet_balance

  private

    def adjust_target_wallet_balance
      target_wallet.update!(balance: target_wallet.balance + amount)
    end
end
