# Create an admin user
User.create!(
    name: 'Admin User',
    email: 'admin@example.com',
    password: 'securepassword', # Make sure to use a strong password in a real application
    password_confirmation: 'securepassword',
    role: 'admin' # This depends on how your User model defines an admin
  )

# Define the CATEGORY_SUBCATEGORIES constant for reference (without prices)
CATEGORY_SUBCATEGORIES = {
  'Web Development' => [
    'Front-End Development',
    'Back-End Development',
    'Full Stack Development',
    'E-commerce Development'
  ],
  'Graphic Design' => [
    'Logo Design',
    'Web Design',
    'Branding & Identity',
    'Social Media Graphics'
  ],
  'Content Writing' => [
    'Blog Writing',
    'Copywriting',
    'Technical Writing',
    'SEO Writing'
  ],
  'App Development' => [
    'Mobile App Development (iOS)',
    'Mobile App Development (Android)',
    'Cross-Platform App Development'
  ],
  'Academics' => [
    'Assignment Writing',
    'Essay Writing',
    'Research Paper Writing',
    'Thesis Writing',
    'Online Tutoring'
  ],
  'Business' => [
    'Business Plan Writing',
    'Market Research',
    'Business Consulting',
    'Financial Analysis',
    'Startup Advice'
  ]
}

# Seed categories and subcategories
CATEGORY_SUBCATEGORIES.each do |category, subcategories|
  # Create the category record
  cat = Category.find_or_create_by(name: category)

  # For each subcategory in the category, create a Subcategory record
  subcategories.each do |subcategory_name|
    Subcategory.find_or_create_by(name: subcategory_name, category: cat)
  end
end
