class AddTeamToInterceptions < ActiveRecord::Migration
  def change
      add_column :sqw_interceptions_events, :sqw_team_id, :integer
  end
end
