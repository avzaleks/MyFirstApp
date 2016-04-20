class AddFotoUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :foto_url, :string
  end
end
