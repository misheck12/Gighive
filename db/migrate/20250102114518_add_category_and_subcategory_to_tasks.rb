class AddCategoryAndSubcategoryToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :category, null: false, foreign_key: true
    add_reference :tasks, :subcategory, null: false, foreign_key: true
  end
end