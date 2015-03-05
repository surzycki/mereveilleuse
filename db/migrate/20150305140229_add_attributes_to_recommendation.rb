class AddAttributesToRecommendation < ActiveRecord::Migration
  def change
    add_column :recommendations, :wait_time,        :integer
    add_column :recommendations, :availability,     :integer
    add_column :recommendations, :bedside_manner,   :integer
    add_column :recommendations, :efficacy,         :integer  
    add_column :recommendations, :comment,          :text  
  end
end
