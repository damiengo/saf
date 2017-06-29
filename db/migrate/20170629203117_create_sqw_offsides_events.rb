class CreateSqwOffsidesEvents < ActiveRecord::Migration
  def change
    create_table :sqw_offsides_events do |t|
      t.references :sqw_player_id, index: true
      t.references :sqw_team_id, index: true
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.references :sqw_game_id, index: true

      t.timestamps
    end
  end
end
