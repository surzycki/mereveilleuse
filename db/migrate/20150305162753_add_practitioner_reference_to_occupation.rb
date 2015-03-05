class AddPractitionerReferenceToOccupation < ActiveRecord::Migration
  def change
    add_reference :occupations, :practitioner, index: true
  end
end
