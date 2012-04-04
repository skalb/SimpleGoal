class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.float :value
      t.datetime :date
      t.references :goal

      t.timestamps
    end
    add_index :targets, :goal_id
  end
end
