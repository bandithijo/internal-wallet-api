class AddKindToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :kind, :string
  end
end
