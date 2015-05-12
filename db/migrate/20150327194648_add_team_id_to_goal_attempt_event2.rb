class AddTeamIdToGoalAttemptEvent2 < ActiveRecord::Migration
  def change
      add_column :sqw_goals_attempts_events, :sqw_team_id, :integer
  end
end
