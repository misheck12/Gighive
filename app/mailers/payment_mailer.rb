class PaymentMailer < ApplicationMailer
  default from: 'bwangubwangu5@gmail.com'

  def payment_created(payment)
    @payment = payment
    @client = payment.task.client
    @freelancer = payment.task.freelancer
    mail(to: @client.email, subject: 'Payment Submitted for Your Task')
  end

  def payment_approved(payment)
    @payment = payment
    @client = payment.task.client
    @freelancer = payment.task.freelancer
    mail(to: @freelancer.email, subject: 'Your Payment Has Been Approved')
  end

  def payment_rejected(payment)
    @payment = payment
    @client = payment.task.client
    @freelancer = payment.task.freelancer
    mail(to: @client.email, subject: 'Your Payment Has Been Rejected')
  end
end