class WalletsController < ApplicationController
  before_action :set_wallet, only: [ :user_balance, :deposit, :withdraw, :transfer ]

  # GET /wallet/user-balance
  def user_balance
    @user_wallet.update_balance!

    data = {
      id: @user_wallet.id,
      updated_at: @user_wallet.updated_at,
      balance: @user_wallet.balance.to_f
    }

    api(data, :ok)
  end

  # GET /wallet/teams-balance
  def teams_balance
    @teams_wallet = Wallet.where(walletable_type: "Team")

    data = @teams_wallet.map { |wallet|
      {
        id: wallet.id,
        updated_at: wallet.updated_at,
        name: Team.find_by(id: wallet.walletable_id).name,
        balance: wallet.balance.to_f
      }
    }

    api(data, :ok)
  end

  # GET /wallet/stocks-balance
  def stocks_balance
    @stocks_wallet = Wallet.where(walletable_type: "Stock")

    data = @stocks_wallet.map { |wallet|
      {
        id: wallet.id,
        updated_at: wallet.updated_at,
        name: Stock.find_by(id: wallet.walletable_id).name,
        symbol: Stock.find_by(id: wallet.walletable_id).symbol,
        balance: wallet.balance.to_f
      }
    }

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
      @user_wallet = current_user.wallet
    end

    def wallet_params
      params.require(:wallet).permit(:amount)
    end

    def transfer_params
      params.require(:transfer).permit(:target_type, :target_id, :amount)
    end
end
