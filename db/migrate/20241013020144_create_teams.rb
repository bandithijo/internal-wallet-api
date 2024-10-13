class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.timestamps

      t.string :name
    end
  end
end
