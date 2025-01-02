class CategoriesController < ApplicationController
  def subcategories
    category = Category.find(params[:id])
    subcategories = category.subcategories.select(:id, :name)
    render json: { subcategories: subcategories }
  end
end
