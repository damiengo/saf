class RemoveSqwGoalAttemptEventFromSqwGoalsPasslink < ActiveRecord::Migration
  def change
    remove_reference :sqw_goal_passlinks, :sqw_goal_attempt
  end
end
