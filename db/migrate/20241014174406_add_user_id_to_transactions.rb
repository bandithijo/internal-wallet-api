class AddUserIdToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_reference :transactions, :user, foreign_key: true
  end
end
