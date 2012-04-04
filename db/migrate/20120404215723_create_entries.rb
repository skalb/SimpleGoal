class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.float :value
      t.datetime :date
      t.references :goal

      t.timestamps
    end
    add_index :entries, :goal_id
  end
end
