class AddProfilImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_image, :string
  end
end
