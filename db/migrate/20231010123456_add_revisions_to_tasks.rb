class AddRevisionsToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :revisions, :integer, default: 1, null: false
  end
end