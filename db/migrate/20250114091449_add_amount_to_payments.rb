class AddAmountToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :amount, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end