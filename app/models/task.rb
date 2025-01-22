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
  before_save :calculate_and_set_budget

  # ---------------------------------------------------------------------------
  # Class Methods
  # ---------------------------------------------------------------------------
  REVISION_COST = 100.freeze # Define revision cost as a constant

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

  # Calculates and sets the budget based on subcategory, complexity, urgency, and revisions
  def calculate_and_set_budget
    return unless subcategory_id.present? && complexity.present? && urgency.present? && revisions.present?

    base_budget = subcategory.minimum_price
    complexity_multiplier = { 'low' => 1.0, 'medium' => 1.2, 'high' => 1.5 }[complexity.downcase] || 1.0
    urgency_multiplier = { 'low' => 1.0, 'normal' => 1.1, 'high' => 1.3 }[urgency.downcase] || 1.0
    extra_revisions = [revisions - 1, 0].max

    self.budget = (base_budget * complexity_multiplier * urgency_multiplier) + (extra_revisions * REVISION_COST)
  end

  # Validates that the budget is above the minimum price for the selected subcategory
  def budget_above_minimum_price
    return unless subcategory.present? && subcategory.minimum_price.present?

    if budget.to_f < subcategory.minimum_price
      errors.add(:budget, "must be at least #{subcategory.minimum_price} ZMK for the selected subcategory.")
    end
  end

  # Sets the completed_at timestamp if the task is completed
  def set_completed_at_if_completed
    if status_changed? && status == 'completed'
      self.completed_at ||= Time.current
    elsif status_changed? && status != 'completed'
      self.completed_at = nil
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