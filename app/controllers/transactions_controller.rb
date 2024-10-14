class TransactionsController < ApplicationController
  # GET /transactions
  def index
    transactions = current_user.wallet.all_transactions.order(created_at: :desc)

    filtering_params(params).each do |key, value|
      transactions = transactions.public_send(key, value) if value.present?
    end

    render json: transactions
  end

  private

    def filtering_params(params)
      params.slice(:wallet_id, :_order)
    end
end
