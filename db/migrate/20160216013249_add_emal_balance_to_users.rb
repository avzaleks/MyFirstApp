class AddEmalBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :balance, :integer
  end
end
