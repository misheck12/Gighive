class PaymentMailer < ApplicationMailer
  default from: 'bwangubwangu5@gmail.com'

  def payment_created(payment)
    @payment = payment
    @client = payment.task.client
    @task = payment.task
    mail(to: @client.email, subject: 'Payment Created for Your Task')
  end

  def payment_approved(payment)
    @payment = payment
    @client = payment.task.client
    @task = payment.task
    mail(to: @client.email, subject: 'Your Payment Has Been Approved')
  end

  def payment_rejected(payment)
    @payment = payment
    @client = payment.task.client
    @task = payment.task
    mail(to: @client.email, subject: 'Your Payment Has Been Rejected')
  end

  def payment_created(payment)
    @payment = payment
    @admin = payment.task.admin
    @task = payment.task
    mail(to: @admin.email, subject: 'Payment Created for Task')
    end

end