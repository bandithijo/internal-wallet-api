class WalletsController < ApplicationController
  before_action :set_wallet, only: [ :show, :deposit, :withdraw, :transfer ]

  # GET /wallet
  def show
    @wallet.update_balance!

    data = { id: @wallet.id, balance: @wallet.balance.to_f }

    api(data, :ok)
  end

  # POST /wallet/deposit
  def deposit
    kind = "DEPOSIT"
    amount = wallet_params[:amount].to_f

    if amount > 0
      Transaction.perform_credit(@wallet, amount, current_user, kind)

      data = { message: "Deposit successful", amount: amount, balance: @wallet.reload.balance.to_f }

      api(data, :ok)
    else
      api({ error: "Invalid amount" }, :unprocessable_entity)
    end
  end

  # POST /wallet/withdraw
  def withdraw
    kind = "WITHDRAW"
    amount = wallet_params[:amount].to_f

    if amount > 0 && @wallet.balance >= amount
      Transaction.perform_debit(@wallet, amount, current_user, kind)

      data = { message: "Withdrawal successful", amount: amount, balance: @wallet.reload.balance.to_f }

      api(data, :ok)
    else
      api({ error: "Insufficient balance or invalid amount" }, :unprocessable_entity)
    end
  end

  # POST /wallet/transfer
  def transfer
    kind = "TRANSFER"
    target_wallet = Wallet.find_by(walletable_type: transfer_params[:target_type], walletable_id: transfer_params[:target_id])
    amount = transfer_params[:amount].to_f

    return api({ error: "Target wallet not found" }, :not_found) if target_wallet.nil?

    return api({ error: "Invalid transfer amount" }, :unprocessable_entity) if amount <= 0

    return api({ error: "Insufficient balance" }, :unprocessable_entity) if @wallet.balance < amount

    ActiveRecord::Base.transaction do
      Transaction.perform_debit(@wallet, amount, current_user, kind)
      Transaction.perform_credit(target_wallet, amount, current_user, kind)
    end

    data = { message: "Transfer successful", amount: amount, balance: @wallet.reload.balance.to_f }

    api(data, :ok)
  rescue ActiveRecord::RecordInvalid => e
    api({ error: e.message }, :unprocessable_entity)
  end

  private

    def set_wallet
      @wallet = current_user.wallet
    end

    def wallet_params
      params.require(:wallet).permit(:amount)
    end

    def transfer_params
      params.require(:transfer).permit(:target_type, :target_id, :amount)
    end
end
