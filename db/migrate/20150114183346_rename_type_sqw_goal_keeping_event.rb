class RenameTypeSqwGoalKeepingEvent < ActiveRecord::Migration
  def change
    rename_column :sqw_goal_keeping_events, :type, :event_type
  end
end
