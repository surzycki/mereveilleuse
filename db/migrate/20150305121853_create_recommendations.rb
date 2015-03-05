class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|

      t.timestamps null: false
    end
  end
end
