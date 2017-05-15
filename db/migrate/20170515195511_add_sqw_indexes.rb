class AddSqwIndexes < ActiveRecord::Migration
  def change
    add_index :sqw_all_passes_events,     :sqw_game_id
    add_index :sqw_goals_attempts_events, :sqw_team_id
    add_index :sqw_interceptions_events,  :sqw_team_id
    add_index :sqw_tackles_events,        :sqw_player_tackled_id
    add_index :sqw_takeons_events,        :sqw_other_player_id
    add_index :sqw_takeons_events,        :sqw_other_team_id
  end
end
