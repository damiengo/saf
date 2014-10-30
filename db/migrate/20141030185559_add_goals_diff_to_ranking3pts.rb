class AddGoalsDiffToRanking3pts < ActiveRecord::Migration
  def change
    add_column :ranking3pts, :goals_diff, :integer
  end
end
