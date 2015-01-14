class AddSqwGameToSqwGoalKeepingEvent < ActiveRecord::Migration
  def change
    add_reference :sqw_goal_keeping_events, :sqw_game, index: true
  end
end
