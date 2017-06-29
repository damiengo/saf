class CreateSqwFoulsEvents < ActiveRecord::Migration
  def change
    create_table :sqw_fouls_events do |t|
      t.references :SqwPlayer, index: true
      t.references :SqwTeam, index: true
      t.integer :sqw_other_player_id
      t.integer :sqw_other_team_id
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.float :loc_x
      t.float :loc_y

      t.timestamps
    end
  end
end
