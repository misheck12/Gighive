class UpdateExistingTasksWithDefaultCategoryAndSubcategory < ActiveRecord::Migration[7.0]
  def up
    default_category = Category.first || Category.create!(name: 'Default Category')
    default_subcategory = default_category.subcategories.first || default_category.subcategories.create!(name: 'Default Subcategory')

    Task.where(category_id: nil).update_all(category_id: default_category.id)
    Task.where(subcategory_id: nil).update_all(subcategory_id: default_subcategory.id)
  end

  def down
    # No need to revert the changes
  end
end