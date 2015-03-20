class CreateSearchesProfessions < ActiveRecord::Migration
  def change
    create_table :searches_professions, id: false do |t|
      t.belongs_to :search,       index: true
      t.belongs_to :profession,   index: true
    end
  end
end
