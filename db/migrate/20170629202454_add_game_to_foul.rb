class AddGameToFoul < ActiveRecord::Migration
  def change
    add_column :sqw_fouls_events, :sqw_game_id, :integer
  end
end
