class ChangeMinimumPriceInSubcategories < ActiveRecord::Migration[7.0]
  def change
    change_column :subcategories, :minimum_price, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end