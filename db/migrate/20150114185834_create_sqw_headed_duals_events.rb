class CreateSqwHeadedDualsEvents < ActiveRecord::Migration
  def change
    create_table :sqw_headed_duals_events do |t|
      t.references :sqw_player, index: true
      t.references :sqw_game, index: true
      t.integer :mins
      t.integer :secs
      t.string :event_type
      t.string :action_type
      t.float :loc_x
      t.float :loc_y
      t.references :otherplayer, index: true

      t.timestamps
    end
  end
end
