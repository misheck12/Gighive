class CategoriesController < ApplicationController
  def subcategories
    category = Category.find(params[:id])
    subcategories = category.subcategories

    render json: { subcategories: subcategories }
  end
end