class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.integer :user_id
      t.string :image_url
      t.string :status
      t.timestamps null: false
    end
  end
end
