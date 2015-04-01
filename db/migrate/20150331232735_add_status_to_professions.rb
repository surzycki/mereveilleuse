class AddStatusToProfessions < ActiveRecord::Migration
  def change
    add_column :professions, :status, :integer, default: 0
  end
end
