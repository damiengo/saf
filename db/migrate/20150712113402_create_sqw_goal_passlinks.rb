class CreateSqwGoalPasslinks < ActiveRecord::Migration
  def change
    create_table :sqw_goal_passlinks do |t|
      t.string :type
      t.string :sub_type
      t.integer :period
      t.integer :player_id
      t.integer :goal_min
      t.float :start_x
      t.float :start_y
      t.boolean :is_own
      t.float :end_x
      t.float :end_y
      t.float :gmouth_y
      t.float :gmouth_z
      t.string :swere
      t.boolean :penalty_goal
      t.integer :club_id
      t.string :side
      t.integer :min
      t.integer :sec
      t.integer :minsec
      t.integer :other_event_playerid
      t.boolean :headed
      t.string :part
      t.string :reason
      t.string :foulcommitted_player
      t.string :foulsuffured_player

      t.timestamps
    end
  end
end
