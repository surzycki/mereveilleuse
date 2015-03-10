class AddStateToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :state, :string, default: 'step_one'
  end
end
