class CreateInsurances < ActiveRecord::Migration
  def change
    create_table :insurances do |t|

      t.timestamps null: false
    end

    create_table :insurances_practitioners, id: false do |t|
      t.belongs_to :insurance,       index: true
      t.belongs_to :practitioner,    index: true
    end
  end
end
