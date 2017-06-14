class AddTeamToGkEvents < ActiveRecord::Migration
  def change
      add_column :sqw_goal_keeping_events, :sqw_team_id, :integer
  end
end
