class AddPositionToSqwPlayerGame < ActiveRecord::Migration
  def change
    add_column :sqw_player_games, :position, :string
  end
end
