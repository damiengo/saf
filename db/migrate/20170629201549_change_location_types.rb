class ChangeLocationTypes < ActiveRecord::Migration
  def change
    change_column :sqw_interceptions_events, :loc_x, :float
    change_column :sqw_interceptions_events, :loc_y, :float
    change_column :sqw_tackles_events, :loc_x, :float
    change_column :sqw_tackles_events, :loc_y, :float
    change_column :sqw_takeons_events, :loc_x, :float
    change_column :sqw_takeons_events, :loc_y, :float
  end
end
