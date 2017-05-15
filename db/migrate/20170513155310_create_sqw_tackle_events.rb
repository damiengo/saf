class CreateSqwTackleEvents < ActiveRecord::Migration
  def change
    create_table :sqw_tackle_events do |t|
      t.references :SqwPlayer, index: true
      t.references :SqwGame, index: true
      t.references :SqwTeam, index: true
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.string :action_type
      t.string :event_type
      t.integer :loc_x
      t.integer :loc_y
      t.integer :sqw_player_tackled_id

      t.timestamps
    end
  end
end
