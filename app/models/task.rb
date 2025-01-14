class Task < ApplicationRecord
  # ---------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------

  belongs_to :category
  belongs_to :subcategory

  belongs_to :client, class_name: 'User'
  belongs_to :freelancer, class_name: 'User', optional: true

  has_many :reviews, dependent: :destroy
  has_one :payment, dependent: :destroy

  # Active Storage Attachments
  has_one_attached :completed_file
  has_one_attached :revised_file
  has_one_attached :attachment

  # ---------------------------------------------------------------------------
  # Enumerations
  # ---------------------------------------------------------------------------

  enum status: { open: 0, in_progress: 1, changes_requested: 2, completed: 3 }

  # ---------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :budget, presence: true, numericality: { greater_than: 0, message: "must be greater than 0" }
  validates :deadline, presence: true
  validates :category_id, presence: true
  validates :subcategory_id, presence: true
  validates :complexity, presence: true
  validates :time_commitment, presence: true
  validates :urgency, presence: true
  validates :revisions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # Custom Validation to ensure budget meets subcategory's minimum price
  validate :budget_above_minimum_price

  # ---------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------

  scope :open_tasks, -> { where(status: :open) }
  scope :completed, -> { where(status: :completed) }


  # ---------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------

  before_validation :set_default_status, on: :create
  before_validation :set_time_commitment
  before_save :adjust_budget_based_on_factors

  # ---------------------------------------------------------------------------
  # Class Methods
  # ---------------------------------------------------------------------------

  # Fetches subcategory options for a given category name
  def self.subcategory_options_for_category(category_name)
    Category.find_by(name: category_name)&.subcategories&.pluck(:name, :id) || []
  end

  # Calculates total earnings for a freelancer based on approved payments
  def self.total_earning_for_freelancer(user_id)
    joins(:payment).where(freelancer_id: user_id, payments: { status: :approved })
  end

  # ---------------------------------------------------------------------------
  # Instance Methods
  # ---------------------------------------------------------------------------

  # Checks if the task has been reviewed
  def reviewed?
    reviews.exists?
  end

  after_create :send_task_created_notification
  after_update :send_task_update_notifications, if: :saved_change_to_status?

  # ---------------------------------------------------------------------------
  # Private Methods
  # ---------------------------------------------------------------------------

  private

  # Sets the default status to 'open' if not already set
  def set_default_status
    self.status ||= :open
  end

  # Sets the time commitment based on the deadline
  def set_time_commitment
    remaining_days = (self.deadline.to_date - Date.today).to_i
    self.time_commitment = if remaining_days <= 7
                              'Short-term'
                            elsif remaining_days <= 30
                              'Medium-term'
                            else
                              'Long-term'
                            end
  end

  # Adjusts the budget based on time commitment, complexity, and revisions
  def adjust_budget_based_on_factors
    return unless budget.present? && time_commitment.present? && complexity.present?

    # Reset budget to base value before applying multipliers
    self.budget = base_budget || budget

    # Apply multipliers
    self.budget = (budget * time_commitment_multiplier * complexity_multiplier).round(2)

    # Adjust budget based on revisions (assuming base revisions = 1)
    if revisions.present? && revisions > 1
      self.budget += (revisions - 1) * revision_cost
    end
  end

  # Retrieves the base budget before any adjustments
  def base_budget
    # Assuming 'base_budget' is a virtual attribute or attribute not persisted to DB
    # If not available, consider storing the original budget or recalculating it
    # For simplicity, we'll assume the entered budget is the base budget
    # If you have a separate field, replace 'budget' with 'base_budget_field'
    budget
  end

  # Defines the multiplier based on time commitment
  def time_commitment_multiplier
    case time_commitment
    when 'Short-term'
      1.2
    when 'Medium-term'
      1.0
    when 'Long-term'
      0.8
    else
      1.0
    end
  end

  # Defines the multiplier based on complexity
  def complexity_multiplier
    case complexity.downcase
    when 'low'
      1.0
    when 'medium'
      1.2
    when 'high'
      1.5
    else
      1.0
    end
  end

  # Adjusts the budget based on the number of revisions
  def adjust_budget_based_on_revisions
    return unless revisions.present? && revisions > 1
    self.budget += (revisions - 1) * revision_cost
  end

  # Defines the additional cost per extra revision
  def revision_cost
    100.0 # Adjust this value as needed
  end

  # Validates that the budget is above the minimum price for the selected subcategory
  def budget_above_minimum_price
    return unless subcategory.present? && subcategory.minimum_price.present?

    if budget < subcategory.minimum_price
      errors.add(:budget, "must be at least #{subcategory.minimum_price} ZMK for the selected subcategory.")
    end
  end

  # ---------------------------------------------------------------------------
  # Notification Methods
  # ---------------------------------------------------------------------------

  def send_task_created_notification
    TaskMailer.task_created(self).deliver_later if client.email.present?
  end

  def send_task_update_notifications
      case status
      when 'in_progress'
        TaskMailer.task_accepted_client(self).deliver_later if client.email.present?
        TaskMailer.task_accepted_freelancer(self).deliver_later if freelancer.email.present?
      when 'completed'
        TaskMailer.task_completed_client(self).deliver_later if client.email.present?
        TaskMailer.task_completed_freelancer(self).deliver_later if freelancer.email.present?
      when 'changes_requested'
        TaskMailer.changes_requested_client(self).deliver_later if client.email.present?
        TaskMailer.changes_requested_freelancer(self).deliver_later if freelancer.email.present?
      end
  end

  def send_changes_submitted_notification
    TaskMailer.changes_submitted_client(self).deliver_later if client.email.present?
    TaskMailer.changes_submitted_freelancer(self).deliver_later if freelancer.email.present?
  end
end