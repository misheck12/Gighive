class TaskMailer < ApplicationMailer
  default from: 'bwangubwangu5@gmail.com'

  def task_created(task)
    @task = task
    @client = task.client
    mail(to: @client.email, subject: 'Your Task Has Been Created')
  end

  def task_accepted_client(task)
    @task = task
    @client = task.client
    @freelancer = task.freelancer
    mail(to: @client.email, subject: "Your Task Has Been Accepted by #{@freelancer.name}")
  end

  def task_accepted_freelancer(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: 'You Have Accepted a Task')
  end

  def task_completed_client(task)
    @task = task
    @client = task.client
    @freelancer = task.freelancer
    mail(to: @client.email, subject: 'Your Task Has Been Completed')
  end

  def task_completed_freelancer(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: 'You Have Completed a Task')
  end

  def changes_requested_client(task)
    @task = task
    @client = task.client
    @freelancer = task.freelancer
    mail(to: @client.email, subject: "Changes Have Been Requested for Your Task - #{@task.title}")
  end

  def changes_requested_freelancer(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: "Changes Requested for Task - #{@task.title}")
  end

  def changes_submitted_client(task)
    @task = task
    @client = task.client
    @freelancer = task.freelancer
    mail(to: @client.email, subject: 'Changes Have Been Submitted for Your Task')
  end

  def changes_submitted_freelancer(task)
    @task = task
    @freelancer = task.freelancer
    mail(to: @freelancer.email, subject: "Changes Have Been Submitted for Task - #{@task.title}")
  end
end