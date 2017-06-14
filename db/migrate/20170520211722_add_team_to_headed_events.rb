class AddTeamToHeadedEvents < ActiveRecord::Migration
  def change
      add_column :sqw_headed_duals_events, :sqw_team_id, :integer
  end
end
