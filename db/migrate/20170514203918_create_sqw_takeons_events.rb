class CreateSqwTakeonsEvents < ActiveRecord::Migration
  def change
    create_table :sqw_takeons_events do |t|
      t.references :sqw_player_id, index: true
      t.references :sqw_game_id, index: true
      t.references :sqw_team_id, index: true
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.string :action_type
      t.string :event_type
      t.integer :loc_x
      t.integer :loc_y
      t.integer :sqw_other_player_id
      t.integer :sqw_other_team_id

      t.timestamps
    end
  end
end
