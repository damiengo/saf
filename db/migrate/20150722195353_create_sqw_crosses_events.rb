class CreateSqwCrossesEvents < ActiveRecord::Migration
  def change
    create_table :sqw_crosses_events do |t|
      t.references :sqw_game, index: true
      t.references :sqw_player, index: true
      t.references :sqw_team, index: true
      t.float :start_x
      t.float :start_y
      t.float :end_x
      t.float :end_y
      t.string :event_type
      t.integer :mins
      t.integer :secs
      t.integer :minsec

      t.timestamps
    end
  end
end
