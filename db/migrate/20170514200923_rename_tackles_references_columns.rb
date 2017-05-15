class RenameTacklesReferencesColumns < ActiveRecord::Migration
  def change
    rename_column :sqw_tackles_events, :SqwPlayer_id, :sqw_player_id
    rename_column :sqw_tackles_events, :SqwGame_id, :sqw_game_id
    rename_column :sqw_tackles_events, :SqwTeam_id, :sqw_team_id
  end
end
