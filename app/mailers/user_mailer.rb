class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def task_notification(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Notification')
  end

  def task_accepted(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Accepted Notification')
  end

  def task_completed(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Completed Notification')
  end

  def password_reset(user)
    @user = user
    @url  = edit_password_reset_url(@user.reset_token, email: @user.email)
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end

  def account_deactivation(user)
    @user = user
    mail(to: @user.email, subject: 'Account Deactivation Notice')
  end

  def new_message_notification(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: 'You Have a New Message')
  end

  def weekly_summary(user)
    @user = user
    @tasks = user.tasks_as_freelancer.where('created_at >= ?', 1.week.ago)
    mail(to: @user.email, subject: 'Your Weekly Summary')
  end

  def task_deadline_reminder(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Deadline Reminder')
  end

  def account_confirmation(user)
    @user = user
    @confirmation_url = user_confirmation_url(@user.confirmation_token)
    mail(to: @user.email, subject: 'Account Confirmation Instructions')
  end

  def comment_notification(user, comment)
    @user = user
    @comment = comment
    mail(to: @user.email, subject: 'New Comment on Your Task')
  end

  def task_status_update(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Task Status Update')
  end

  def review_received(user, review)
    @user = user
    @review = review
    mail(to: @user.email, subject: 'You Have Received a New Review')
  end
end
