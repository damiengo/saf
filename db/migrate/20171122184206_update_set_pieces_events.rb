class UpdateSetPiecesEvents < ActiveRecord::Migration
  def change
    rename_column :sqw_setpieces_events, :pass_player_id,     :sqw_pass_player_id
    rename_column :sqw_setpieces_events, :pass_team_id,       :sqw_pass_team_id
    rename_column :sqw_setpieces_events, :shot_team,          :sqw_shot_team_id
    add_column    :sqw_setpieces_events, :sqw_shot_player_id, :integer
    add_column    :sqw_setpieces_events, :sqw_game_id,        :integer
  end
end
