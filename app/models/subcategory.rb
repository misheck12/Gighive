class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :tasks, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :category_id }
  validates :minimum_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end