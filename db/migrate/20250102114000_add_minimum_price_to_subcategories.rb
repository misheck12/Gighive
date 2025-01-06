class AddMinimumPriceToSubcategories < ActiveRecord::Migration[7.0]
  def change
    add_column :subcategories, :minimum_price, :integer
  end
end
