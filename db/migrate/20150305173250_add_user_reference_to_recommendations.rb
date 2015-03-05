class AddUserReferenceToRecommendations < ActiveRecord::Migration
  def change
    add_reference :recommendations, :user, index: true
  end
end
