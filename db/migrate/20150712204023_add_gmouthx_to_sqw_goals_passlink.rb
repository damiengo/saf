class AddGmouthxToSqwGoalsPasslink < ActiveRecord::Migration
  def change
    add_column :sqw_goal_passlinks, :gmouth_x, :float
  end
end
