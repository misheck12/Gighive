class AddCategoryAndSubcategoryToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :category, foreign_key: true
    add_reference :tasks, :subcategory, foreign_key: true
  end
end