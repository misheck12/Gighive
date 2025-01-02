class Task < ApplicationRecord

  CATEGORY_SUBCATEGORIES = {
    'Web Development' => {
      'Front-End Development' => 1_000,
      'Back-End Development' => 1_500,
      'Full Stack Development' => 2_500,
      'E-commerce Development' => 2_000
    },
    'Graphic Design' => {
      'Logo Design' => 800,
      'Web Design' => 1_000,
      'Branding & Identity' => 1_200,
      'Social Media Graphics' => 500
    },
    'Content Writing' => {
      'Blog Writing' => 500,
      'Copywriting' => 800,
      'Technical Writing' => 1_000,
      'SEO Writing' => 700
    },
    'App Development' => {
      'Mobile App Development (iOS)' => 2_000,
      'Mobile App Development (Android)' => 2_000,
      'Cross-Platform App Development' => 3_000
    },
    'Academics' => {
      'Assignment Writing' => 300,
      'Essay Writing' => 500,
      'Research Paper Writing' => 800,
      'Thesis Writing' => 1_500,
      'Online Tutoring' => 500
    },
    'Business' => {
      'Business Plan Writing' => 1_000,
      'Market Research' => 800,
      'Business Consulting' => 1_500,
      'Financial Analysis' => 1_200,
      'Startup Advice' => 1_000
    }
  }

  def self.subcategory_options_for_category(category)
    Category.find_by(name: category)&.subcategories&.pluck(:name, :id) || []
  end

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :budget, presence: true, numericality: { greater_than: 0, message: "must be greater than 0" }
  validates :deadline, presence: true
  validates :category_id, presence: true
  validates :subcategory_id, presence: true
  validates :complexity, presence: true
  validates :time_commitment, presence: true
  validates :urgency, presence: true
  validates :revisions, presence: true
  validate :budget_above_minimum_price

  has_one_attached :completed_file
  has_one_attached :revised_file
  has_one_attached :attachment

  # Enum for status
  enum status: { open: 0, in_progress: 1, changes_requested: 2, completed: 3 }

  # Callback to set default status
  before_validation :set_default_status, on: :create

  # Scopes
  scope :open_tasks, -> { where(status: :open) } 

  # Associations
  belongs_to :client, class_name: 'User'
  belongs_to :freelancer, class_name: 'User', optional: true
  belongs_to :category
  belongs_to :subcategory

  has_many :reviews, dependent: :destroy
  has_one :payment, dependent: :destroy

  def reviewed?
    reviews.exists?
  end

  def self.total_earning_for_freelancer(user_id)
    joins(:payment).where(freelancer_id: user_id, payments: {status: :approved})
  end

  private

  # Set default status
  def set_default_status
    self.status ||= :open
  end

  # Validate that the budget is above the minimum price for the selected subcategory
  def budget_above_minimum_price
    min_price = subcategory.minimum_price || 0
  
    if budget < min_price
      errors.add(:budget, "must be at least #{min_price} ZMK for the selected subcategory.")
    end
  end

end