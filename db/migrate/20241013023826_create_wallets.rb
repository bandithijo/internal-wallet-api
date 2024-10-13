class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.timestamps

      t.references :walletable, polymorphic: true, null: false
      t.decimal :balance, precision: 10, scale: 2
    end
  end
end
