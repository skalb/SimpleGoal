class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.float :value
      t.references :user

      t.timestamps
    end
    add_index :goals, :user_id
  end
end
