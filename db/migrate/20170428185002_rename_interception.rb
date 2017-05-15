class RenameInterception < ActiveRecord::Migration
  def self.up
    rename_table :sqw_interceptions, :sqw_interception_events
  end

  def self.down
    rename_table :sqw_interception_events, :sqw_interceptions
  end
end
