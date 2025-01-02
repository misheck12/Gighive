class CategoriesController < ApplicationController
  before_action :authenticate_user!  # Optional: Ensure users are authenticated

  def subcategories
    category = Category.find(params[:id])
    subcategories = category.subcategories.select(:id, :name)
    render json: { subcategories: subcategories }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end
end