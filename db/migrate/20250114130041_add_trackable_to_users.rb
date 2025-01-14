class AddTrackableToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

    # Adding indexes for faster queries on IP address fields
    add_index :users, :current_sign_in_ip
    add_index :users, :last_sign_in_ip
  end
end