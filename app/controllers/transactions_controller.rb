class TransactionsController < ApplicationController
  # GET /transactions
  def index
    transactions = current_user.transactions.order(created_at: :desc)

    filtering_params(params).each do |key, value|
      transactions = transactions.public_send(key, value) if value.present?
    end

    render json: transactions.map { |transaction|
      {
        id: transaction.id,
        created_at: transaction.created_at,
        type: transaction.type,
        source_wallet: transaction.source_wallet&.walletable&.name,
        target_wallet: transaction.target_wallet&.walletable&.name,
        amount: transaction.amount.to_f
      }
    }
  end

  private

    def filtering_params(params)
      params.slice(:type, :_order)
    end
end
