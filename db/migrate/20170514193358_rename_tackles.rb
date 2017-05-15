class RenameTackles < ActiveRecord::Migration
  def self.up
    rename_table :sqw_tackle_events, :sqw_tackles_events
  end

  def self.down
    rename_table :sqw_tackles_events, :sqw_tackle_events
  end
end
