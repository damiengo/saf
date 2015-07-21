class AddGameToSqwAllPassesEvent < ActiveRecord::Migration
  def change
    add_column :sqw_all_passes_events, :sqw_game_id, :integer
  end
end
