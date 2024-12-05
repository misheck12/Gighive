#!/bin/bash

# Function to create a file with content if it doesn't already exist
create_file_if_not_exists() {
  local file_path=$1
  local content=$2

  if [ ! -f "$file_path" ]; then
    echo "$content" > "$file_path"
    echo "Created file: $file_path"
  else
    echo "File already exists: $file_path"
  fi
}

# Function to create a directory if it doesn't already exist
create_directory_if_not_exists() {
  local dir_path=$1

  if [ ! -d "$dir_path" ]; then
    mkdir -p "$dir_path"
    echo "Created directory: $dir_path"
  else
    echo "Directory already exists: $dir_path"
  fi
}

# Create directories for mailer views
create_directory_if_not_exists "app/views/user_mailer"

# Define the content for each view
welcome_email_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Welcome to My Awesome Site, <%= @user.name %>!</h1>
  <p>
    You have successfully signed up to my awesome site,
    your username is: <%= @user.email %>.<br>
    To login to the site, just follow this link: <%= @url %>.
  </p>
</body>
</html>'

task_notification_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Hi, <%= @user.name %>!</h1>
  <p>
    You have a new task: <%= @task.title %>.<br>
    Description: <%= @task.description %>.<br>
    Due date: <%= @task.due_date %>.
  </p>
</body>
</html>'

task_accepted_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Hi, <%= @user.name %>!</h1>
  <p>Your task "<%= @task.title %>" has been accepted and is now in progress.</p>
</body>
</html>'

task_completed_content='<!DOCTYPE html>
<html>
head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Hi, <%= @user.name %>!</h1>
  <p>Your task "<%= @task.title %>" has been completed.</p>
</body>
</html>'

password_reset_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Password Reset Instructions</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>You can reset your password by following this link: <%= @url %></p>
</body>
</html>'

account_deactivation_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Account Deactivation Notice</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>Your account has been deactivated.</p>
</body>
</html>'

new_message_notification_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>New Message Notification</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>You have a new message: <%= @message.content %></p>
</body>
</html>'

weekly_summary_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Your Weekly Summary</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>Here is a summary of your activities for the past week:</p>
  <ul>
    <% @tasks.each do |task| %>
      <li><%= task.title %> - <%= task.status %></li>
    <% end %>
  </ul>
</body>
</html>'

task_deadline_reminder_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Task Deadline Reminder</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>This is a reminder that the deadline for your task "<%= @task.title %>" is approaching.</p>
</body>
</html>'

account_confirmation_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Account Confirmation Instructions</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>You can confirm your account by following this link: <%= @confirmation_url %></p>
</body>
</html>'

comment_notification_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>New Comment on Your Task</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>You have a new comment on your task: <%= @comment.content %></p>
</body>
</html>'

task_status_update_content='<!DOCTYPE html>
<html>
<head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>Task Status Update</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>The status of your task "<%= @task.title %>" has been updated to "<%= @task.status %>".</p>
</body>
</html>'

review_received_content='<!DOCTYPE html>
<html>
head>
  <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
</head>
<body>
  <h1>New Review Received</h1>
  <p>Hi, <%= @user.name %>!</p>
  <p>You have received a new review on your task: "<%= @review.task.title %>".</p>
  <p>Rating: <%= @review.rating %></p>
  <p>Comment: <%= @review.comment %></p>
</body>
</html>'

# Create the view files
create_file_if_not_exists "app/views/user_mailer/welcome_email.html.erb" "$welcome_email_content"
create_file_if_not_exists "app/views/user_mailer/task_notification.html.erb" "$task_notification_content"
create_file_if_not_exists "app/views/user_mailer/task_accepted.html.erb" "$task_accepted_content"
create_file_if_not_exists "app/views/user_mailer/task_completed.html.erb" "$task_completed_content"
create_file_if_not_exists "app/views/user_mailer/password_reset.html.erb" "$password_reset_content"
create_file_if_not_exists "app/views/user_mailer/account_deactivation.html.erb" "$account_deactivation_content"
create_file_if_not_exists "app/views/user_mailer/new_message_notification.html.erb" "$new_message_notification_content"
create_file_if_not_exists "app/views/user_mailer/weekly_summary.html.erb" "$weekly_summary_content"
create_file_if_not_exists "app/views/user_mailer/task_deadline_reminder.html.erb" "$task_deadline_reminder_content"
create_file_if_not_exists "app/views/user_mailer/account_confirmation.html.erb" "$account_confirmation_content"
create_file_if_not_exists "app/views/user_mailer/comment_notification.html.erb" "$comment_notification_content"
create_file_if_not_exists "app/views/user_mailer/task_status_update.html.erb" "$task_status_update_content"
create_file_if_not_exists "app/views/user_mailer/review_received.html.erb" "$review_received_content"

echo "Views created successfully."

