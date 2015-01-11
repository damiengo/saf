class AddTeamColorToSqwTeam < ActiveRecord::Migration
  def change
    add_column :sqw_teams, :team_color, :string
  end
end
