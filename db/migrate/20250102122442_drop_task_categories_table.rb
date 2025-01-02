class DropTaskCategoriesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :task_categories, if_exists: true
  end

  def down
    create_table :task_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end