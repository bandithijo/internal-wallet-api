class CreateUserTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :user_tokens do |t|
      t.timestamps

      t.references :user, null: false, foreign_key: true
      t.string :token
      t.datetime :token_expired_at
    end
    add_index :user_tokens, :token
  end
end
