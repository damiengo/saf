class RemoveColorFromSqwTeam2 < ActiveRecord::Migration
  def change
      remove_column :sqw_teams, :color
  end
end
