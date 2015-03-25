class AddNameToHelpTopics < ActiveRecord::Migration
  def change
    add_column :help_topics, :name, :string
  end
end
