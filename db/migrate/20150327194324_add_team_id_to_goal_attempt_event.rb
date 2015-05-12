class AddTeamIdToGoalAttemptEvent < ActiveRecord::Migration
  def change
      add_reference :sqw_teams, :sqw_team, index: true
  end
end
