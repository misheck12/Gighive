class PaymentMailer < ApplicationMailer
  default from: 'bwangubwangu5@gmail.com'

  def payment_created(payment)
    @payment = payment
    @client = payment.client
    @task = payment.task
    mail(to: @client.email, subject: 'Payment Created for Your Task')
  end

  def payment_approved(payment)
    @payment = payment
    @freelancer = payment.task.freelancer
    @task = payment.task
    mail(to: @freelancer.email, subject: 'Your Payment Has Been Approved')
  end

  def payment_rejected(payment)
    @payment = payment
    @freelancer = payment.task.freelancer
    @task = payment.task
    mail(to: @freelancer.email, subject: 'Your Payment Has Been Rejected')
  end
end