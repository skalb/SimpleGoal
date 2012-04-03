class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :date
      t.float :value
      t.references :goal

      t.timestamps
    end
    add_index :entries, :goal_id
  end
end
