class RenameOffsidesReferences < ActiveRecord::Migration
  def change
    rename_column :sqw_offsides_events, :sqw_player_id_id, :sqw_player_id
    rename_column :sqw_offsides_events, :sqw_team_id_id, :sqw_team_id
    rename_column :sqw_offsides_events, :sqw_game_id_id, :sqw_game_id
  end
end
