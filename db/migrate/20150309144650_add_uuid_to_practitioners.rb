class AddUuidToPractitioners < ActiveRecord::Migration
  def change
    add_column :practitioners, :uuid, :string
  end
end
