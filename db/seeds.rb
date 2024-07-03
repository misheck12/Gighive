# Create an admin user
User.create!(
    name: 'Admin User',
    email: 'admin@example.com',
    password: 'securepassword', # Make sure to use a strong password in a real application
    password_confirmation: 'securepassword',
    role: 'admin' # This depends on how your User model defines an admin
  )
  
  