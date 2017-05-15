class RenameTakeonsIds < ActiveRecord::Migration
  def change
    rename_column :sqw_takeons_events, :sqw_player_id_id, :sqw_player_id
    rename_column :sqw_takeons_events, :sqw_game_id_id, :sqw_game_id
    rename_column :sqw_takeons_events, :sqw_team_id_id, :sqw_team_id
  end
end
