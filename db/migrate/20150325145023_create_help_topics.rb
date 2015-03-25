class CreateHelpTopics < ActiveRecord::Migration
  def change
    create_table :help_topics do |t|

      t.timestamps null: false
    end
  end
end
