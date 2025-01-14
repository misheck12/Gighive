class Payment < ApplicationRecord
  belongs_to :client, class_name: 'User', optional: true
  belongs_to :task
  belongs_to :user
  belongs_to :budget

  has_one_attached :payment_proof

  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :amount, presence: true, numericality: { greater_than: 0 }

  after_create :send_payment_created_notification
  after_update :send_payment_status_change_notification, if: :saved_change_to_status?

  private

  def send_payment_created_notification
    PaymentMailer.payment_created(self).deliver_later
  end

  def send_payment_status_change_notification
    case status
    when 'approved'
      PaymentMailer.payment_approved(self).deliver_later
    when 'rejected'
      PaymentMailer.payment_rejected(self).deliver_later
    end
  end
end