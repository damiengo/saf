class RenameFoulsReferences < ActiveRecord::Migration
  def change
    rename_column :sqw_fouls_events, :SqwPlayer_id, :sqw_player_id
    rename_column :sqw_fouls_events, :SqwTeam_id, :sqw_team_id
  end
end
