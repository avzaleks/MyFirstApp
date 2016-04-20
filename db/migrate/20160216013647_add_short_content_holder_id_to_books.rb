class AddShortContentHolderIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :short_content, :string
    add_column :books, :holder_id, :integer
  end
end
