class RenameInterceptions < ActiveRecord::Migration
  def self.up
    rename_table :sqw_interception_events, :sqw_interceptions_events
  end

  def self.down
    rename_table :sqw_interceptions_events, :sqw_interception_events
  end
end
