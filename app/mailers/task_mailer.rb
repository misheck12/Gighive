class TaskMailer < ApplicationMailer
  default from: 'bwangubwangu5@gmail.com'

  def task_created(task)
    @task = task
    @client = task.client
    mail(to: @client.email, subject: 'Your Task Has Been Created')
  end

  def task_accepted(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: 'You Have Accepted a Task')
  end

  def task_completed(task)
    @task = task
    @client = task.client
    @freelancer = task.freelancer
    mail(to: @client.email, subject: 'Your Task Has Been Completed')
  end

  def changes_requested(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: 'Changes Requested for Your Task')
  end

  def changes_submitted(task)
    @task = task
    @client = task.client
    @freelancer = task.freelancer
    mail(to: @client.email, subject: 'Changes Have Been Submitted for Your Task')
  end
end