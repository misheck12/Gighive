class TaskPriceUpdateJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id) # Use find_by to avoid raising an error if not found
    return if task.nil? # Skip if the task doesn't exist

    begin
      final_price = calculate_task_price(task)
      task.update!(budget: final_price)

      # Send notification after successful update
      # TaskMailer.task_price_updated(task).deliver_later # Consider deliver_later for better performance

    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Error updating task #{task_id}: #{e.message}"
      # Potentially:
      # - Requeue the job with a delay (if using a system that supports it)
      # - Notify an administrator about the error
    rescue StandardError => e
      Rails.logger.error "An unexpected error occurred during task price update for task #{task_id}: #{e.message}"
      # Handle other potential errors (e.g., mailer errors)
    end
  end

  private

  def calculate_task_price(task)
    base_price = task.subcategory&.minimum_price || 0
    complexity_factor = PricingFactor.for('complexity', task.complexity)
    urgency_factor = PricingFactor.for('urgency', task.urgency)
    revisions = task.revisions.presence || 1
    (base_price * complexity_factor * urgency_factor * revisions).round(2)
  end
end

# Example using a PricingFactor model (you might prefer a different approach)
class PricingFactor < ApplicationRecord
  validates :factor_type, presence: true
  validates :level, presence: true
  validates :value, presence: true

  def self.for(factor_type, level)
    find_by(factor_type: factor_type, level: level)&.value || 1.0
  end
end