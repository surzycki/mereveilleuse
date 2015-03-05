class AddAttributesToPractitioners < ActiveRecord::Migration
  def change
    add_column :practitioners, :firstname,     :string
    add_column :practitioners, :lastname,      :string
    add_column :practitioners, :email,         :string
    add_column :practitioners, :phone,         :string
    add_column :practitioners, :mobile_phone,  :string
  end
end
