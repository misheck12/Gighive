class AddPaymentFieldsToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :reference_no, :string
    add_column :tasks, :transaction_id, :string
  end
end
