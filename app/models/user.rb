class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable, :trackable

  # Enum for roles
  enum role: { client: 0, admin: 1, freelancer: 2 }

  attr_accessor :terms_of_service

  # Associations
  has_many :tasks_as_client, class_name: 'Task', foreign_key: 'client_id'
  has_many :tasks_as_freelancer, class_name: 'Task', foreign_key: 'freelancer_id'
  has_many :given_reviews, class_name: 'Review', foreign_key: 'reviewer_id'
  has_one_attached :photo
  has_many :payments, dependent: :destroy
  
  # This new association will allow freelancers to access the reviews they've received
  has_many :reviews_received, through: :tasks_as_freelancer, source: :reviews
  has_many :tasks_completed, -> { completed }, class_name: 'Task', foreign_key: 'freelancer_id'


  # Callbacks
  after_initialize :set_default_role, if: :new_record?

  validates :name, presence: true, length: { maximum: 255 } 

  def tasks_requiring_changes
    tasks_as_freelancer.where(status: 'changes_requested')
  end

 # Calculate total earnings for the freelancer based on approved payments
 def total_earning_for_freelancer(user_id)
  payments.joins(:task).where(status: 'approved').sum('tasks.budget')
end

  private

  def set_default_role
    self.role ||= :client
  end
end
