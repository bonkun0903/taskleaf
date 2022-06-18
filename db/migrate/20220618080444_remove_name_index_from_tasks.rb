class RemoveNameIndexFromTasks < ActiveRecord::Migration[7.0]
  def up
    remove_index :tasks, column: :name, unique: true
  end

  def down
    remove_index :tasks, column: :name, unique: true
  end
end
