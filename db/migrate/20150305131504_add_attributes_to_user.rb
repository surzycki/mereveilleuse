class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id,   :string
    add_column :users, :firstname,     :string
    add_column :users, :lastname,      :string
    add_column :users, :email,         :string
    add_column :users, :has_invited,   :boolean
  end
end
