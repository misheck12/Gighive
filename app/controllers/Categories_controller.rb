# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  before_action :authenticate_user!  # Ensure users are authenticated if required


  def subcategories
    category = Category.find(params[:id])
    subcategories = category.subcategories.select(:id, :name, :minimum_price)

    Rails.logger.debug "Fetched subcategories for Category ID #{category.id}: #{subcategories.pluck(:name).join(', ')}"

    render json: { subcategories: subcategories }
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Category not found: ID #{params[:id]}"
    render json: { error: 'Category not found' }, status: :not_found
  end
end