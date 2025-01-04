class AddDetailsToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :complexity, :string
    add_column :tasks, :time_commitment, :string
    add_column :tasks, :urgency, :string
  end
end
