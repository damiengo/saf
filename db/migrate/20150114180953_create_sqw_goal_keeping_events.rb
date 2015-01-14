class CreateSqwGoalKeepingEvents < ActiveRecord::Migration
  def change
    create_table :sqw_goal_keeping_events do |t|
      t.string :type
      t.references :sqw_player, index: true
      t.string :action_type
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.boolean :headed
      t.float :loc_x
      t.float :loc_y

      t.timestamps
    end
  end
end
