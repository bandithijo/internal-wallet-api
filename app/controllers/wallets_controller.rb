class WalletsController < ApplicationController
  before_action :set_wallet, only: [ :show, :deposit, :withdraw, :transfer ]

  # GET /wallet
  def show
    @wallet.update_balance!

    render json: { id: @wallet.id, balance: @wallet.balance.to_f }
  end

  # POST /wallet/deposit
  def deposit
    amount = wallet_params[:amount].to_f

    if amount > 0
      Transaction.perform_credit(@wallet, amount, current_user)

      render json: { message: "Deposit successful", amount: amount, balance: @wallet.reload.balance.to_f }, status: :ok
    else
      render json: { error: "Invalid amount" }, status: :unprocessable_entity
    end
  end

  # POST /wallet/withdraw
  def withdraw
    amount = wallet_params[:amount].to_f

    if amount > 0 && @wallet.balance >= amount
      Transaction.perform_debit(@wallet, amount, current_user)

      render json: { message: "Withdrawal successful", amount: amount, balance: @wallet.reload.balance.to_f }, status: :ok
    else
      render json: { error: "Insufficient balance or invalid amount" }, status: :unprocessable_entity
    end
  end

  # POST /wallet/transfer
  def transfer
    target_wallet = Wallet.find_by(walletable_type: transfer_params[:target_type], walletable_id: transfer_params[:target_id])
    amount = transfer_params[:amount].to_f

    return render json: { error: "Target wallet not found" }, status: :not_found if target_wallet.nil?

    return render json: { error: "Invalid transfer amount" }, status: :unprocessable_entity if amount <= 0

    return render json: { error: "Insufficient balance" }, status: :unprocessable_entity if @wallet.balance < amount

    ActiveRecord::Base.transaction do
      Transaction.perform_debit(@wallet, amount, current_user)
      Transaction.perform_credit(target_wallet, amount, current_user)
    end

    render json: { message: "Transfer successful", amount: amount, balance: @wallet.reload.balance.to_f }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
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
