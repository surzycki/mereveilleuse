class CreateFederations < ActiveRecord::Migration
  def change
    create_table :federations do |t|

      t.timestamps null: false
    end

    create_table :federations_practitioners, id: false do |t|
      t.belongs_to :federation,      index: true
      t.belongs_to :practitioner,    index: true
    end
  end
end
