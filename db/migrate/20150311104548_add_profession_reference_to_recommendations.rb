class AddProfessionReferenceToRecommendations < ActiveRecord::Migration
  def change
    add_reference :recommendations, :profession, index: true
  end
end
