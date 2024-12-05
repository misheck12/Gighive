class AddTaskCategoryToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :task_category, null: false, foreign_key: true
  end
end
