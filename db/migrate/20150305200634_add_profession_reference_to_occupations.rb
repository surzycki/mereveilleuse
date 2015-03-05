class AddProfessionReferenceToOccupations < ActiveRecord::Migration
  def change
    add_reference :occupations, :profession, index: true
  end
end
