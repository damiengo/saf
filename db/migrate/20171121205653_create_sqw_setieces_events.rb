class CreateSqwSetiecesEvents < ActiveRecord::Migration
  def change
    create_table :sqw_setpieces_events do |t|
      t.integer :pass_player_id
      t.integer :pass_team_id
      t.integer :pass_minsec
      t.float :pass_start_x
      t.float :pass_start_y
      t.float :pass_end_x
      t.float :pass_end_y
      t.float :shot_start_x
      t.float :shot_start_y
      t.integer :shot_minsec
      t.integer :shot_team
      t.string :event_type

      t.timestamps
    end
  end
end
