class AddStatusEnumToPractitioners < ActiveRecord::Migration
  def change
    add_column :practitioners, :status, :integer, default: 0
  end
end
