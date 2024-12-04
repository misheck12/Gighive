class TaskMailer < ApplicationMailer
  default from: 'no-reply@gighive.com'

  # Email when a task is created
  def task_created(task)
    @task = task
    @client = task.client
    mail(to: @client.email, subject: 'Your Task Has Been Created')
  end

  # Email when a task is assigned to a freelancer
  def task_assigned(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: 'A New Task Has Been Assigned to You')
  end

  # Email when a task is completed
  def task_completed(task)
    @task = task
    @client = task.client
    mail(to: @client.email, subject: 'Your Task Has Been Completed')
  end

  # Email when a change request is made
  def change_requested(task)
    @task = task
    @freelancer = task.freelancer
    @client = task.client
    mail(to: @freelancer.email, subject: 'Change Requested for Your Task')
  end
end
