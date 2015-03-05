class AddPractitionerReferenceToRecommendations < ActiveRecord::Migration
  def change
    add_reference :recommendations, :practitioner, index: true
  end
end
