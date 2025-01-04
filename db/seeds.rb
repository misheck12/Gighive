

# Create an admin user if not already present
admin_email = 'admin@example.com'
admin = User.find_or_initialize_by(email: admin_email)
if admin.new_record?
  admin.name = 'Admin User'
  admin.password = 'securepassword' # In production, ensure to use environment variables or secure methods
  admin.password_confirmation = 'securepassword'
  admin.role = 'admin' # Adjust based on your User model's role implementation
  admin.save!
  puts "Admin user created with email: #{admin.email}"
else
  puts "Admin user already exists with email: #{admin.email}"
end

# Define categories, subcategories, and their minimum prices
CATEGORY_SUBCATEGORIES_WITH_PRICES = {
  'Web Development' => {
    'Front-End Development' => 1_500,
    'Back-End Development' => 2_000,
    'Full Stack Development' => 4_500,
    'E-commerce Development' => 10_000,
    'CMS Development' => 20_00,
    'Website Maintenance' => 1_500
  },
  'Graphic Design' => {
    'Logo Design' => 800,
    'Web Design' => 1_900,
    'Branding & Identity' => 2_500,
    'Social Media Graphics' => 900,
    'Infographic Design' => 600,
    'Print Design' => 700
  },
  'Content Writing' => {
    'Blog Writing' => 500,
    'Copywriting' => 800,
    'Technical Writing' => 1_000,
    'SEO Writing' => 700,
    'Newsletter Writing' => 600,
    'Ghostwriting' => 900
  },
  'App Development' => {
    'Mobile App Development (iOS)' => 2_900,
    'Mobile App Development (Android)' => 2_900,
    'Cross-Platform App Development' => 3_000,
    'App UI/UX Design' => 1_500,
    'App Maintenance' => 1_200
  },
  'Academics' => {
    'Assignment Writing' => 300,
    'Essay Writing' => 500,
    'Research Paper Writing' => 1_000,
    'Thesis Writing' => 3_000,
    'Research Proposal' => 1_000,
    'Academic Editing' => 1_000
  },
  'Business' => {
    'Business Plan Writing' => 1_000,
    'Market Research' => 800,
    'Business Consulting' => 1_500,
    'Financial Analysis' => 2_000,
    'Startup Advice' => 1_500,
    'Strategic Planning' => 2_300,
    'Pitch Deck Creation' => 1_900
  }
}

# Seed categories and subcategories with minimum prices
CATEGORY_SUBCATEGORIES_WITH_PRICES.each do |category_name, subcategories|
  # Create or find the category
  category = Category.find_or_create_by!(name: category_name)
  puts "Processing Category: #{category.name}"

  subcategories.each do |subcategory_name, minimum_price|
    # Create or find the subcategory with the associated category and minimum_price
    subcategory = Subcategory.find_or_create_by!(name: subcategory_name, category: category) do |sub|
      sub.minimum_price = minimum_price
    end

    # Update minimum_price if it has changed
    if subcategory.minimum_price != minimum_price
      subcategory.update!(minimum_price: minimum_price)
      puts "Updated minimum_price for Subcategory: #{subcategory.name} to #{minimum_price} ZMK"
    else
      puts "Subcategory already exists: #{subcategory.name} with minimum_price: #{subcategory.minimum_price} ZMK"
    end
  end
end

puts "Seeding completed successfully."