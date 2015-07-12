class AddSqwGoalAttemptEventToSqwGoalsPasslink < ActiveRecord::Migration
  def change
    add_reference :sqw_goal_passlinks, :sqw_goals_attempts_event, index: true
  end
end
