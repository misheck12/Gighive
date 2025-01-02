class TaskCategory < ApplicationRecord
  has_many :tasks, foreign_key: :category, primary_key: :name
end
