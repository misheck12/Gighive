

# Create an admin user if not already present
admin_email = 'misheck@bwangubwangu.net'
admin = User.find_or_initialize_by(email: admin_email)
if admin.new_record?
  admin.name = 'Misheck Livingi'
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
    'Front-End Development' => 2_000,
    'Back-End Development' => 2_500,
    'Full Stack Development' => 5_000,
    'E-commerce Development' => 12_000,
    'CMS Development' => 2_500,
    'Website Maintenance' => 1_800
  },

  'Graphic Design' => {
    'Logo Design' => 1_000,
    'Web Design' => 2_500,
    'Branding & Identity' => 3_000,
    'Social Media Graphics' => 800,
    'Infographic Design' => 700,
    'Print Design' => 900
  },

  'Content Writing' => {
    'Blog Writing' => 600,
    'Copywriting' => 1_000,
    'Technical Writing' => 1_200,
    'SEO Writing' => 900,
    'Newsletter Writing' => 700,
    'Ghostwriting' => 1_200
  },

  'App Development' => {
    'Mobile App Development (iOS)' => 3_500,
    'Mobile App Development (Android)' => 3_500,
    'Cross-Platform App Development' => 4_000,
    'App UI/UX Design' => 2_000,
    'App Maintenance' => 1_500
  },

  'Academics' => {
    'Assignment Writing' => 400,
    'Essay Writing' => 600,
    'Research Paper Writing' => 1_200,
    'Thesis Writing' => 3_500,
    'Research Proposal' => 1_200,
    'Academic Editing' => 1_200
  },

  'Business' => {
    'Business Plan Writing' => 1_500,
    'Market Research' => 1_200,
    'Business Consulting' => 2_000,
    'Financial Analysis' => 2_500,
    'Startup Advice' => 2_000,
    'Strategic Planning' => 3_000,
    'Pitch Deck Creation' => 2_500
  },

  'Digital Marketing' => {
    'Social Media Marketing' => 1_200,
    'SEO Optimization' => 2_000,
    'Pay-Per-Click (PPC) Advertising' => 2_500,
    'Email Marketing Campaigns' => 1_000,
    'Content Marketing Strategy' => 1_800
  },

  'Data & Analytics' => {
    'Data Analysis' => 2_000,
    'Data Visualization' => 1_500,
    'Dashboard Creation' => 2_500,
    'Data Cleaning' => 1_000,
    'Statistical Analysis' => 2_000
  },

  'Video & Animation' => {
    'Explainer Videos' => 3_000,
    '2D Animation' => 2_500,
    'Video Editing' => 1_800,
    'Logo Animation' => 1_200,
    'Social Media Video Creation' => 1_500
  },

  'IT & Networking' => {
    'Network Setup' => 2_500,
    'Network Troubleshooting' => 1_500,
    'IT Support' => 1_000,
    'Cloud Migration' => 4_000,
    'VPN Configuration' => 2_000
  },

  'Virtual Assistance' => {
    'Data Entry' => 400,
    'Email Management' => 500,
    'Calendar Management' => 600,
    'Research Tasks' => 800,
    'Customer Support' => 1_000
  },

  'E-Learning' => {
    'Course Creation' => 2_000,
    'Quiz Development' => 600,
    'Interactive Content Design' => 1_500,
    'Learning Management System Setup' => 4_000,
    'Online Tutoring' => 1_500
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