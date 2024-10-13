class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.timestamps

      t.string :name
      t.string :symbol
    end
  end
end
