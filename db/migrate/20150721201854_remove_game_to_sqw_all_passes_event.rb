class RemoveGameToSqwAllPassesEvent < ActiveRecord::Migration
  def change
    remove_column :sqw_all_passes_events, :game_id
  end
end
