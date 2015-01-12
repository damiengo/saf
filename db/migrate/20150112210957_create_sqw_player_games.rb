class CreateSqwPlayerGames < ActiveRecord::Migration
  def change
    create_table :sqw_player_games do |t|
      t.references :sqw_game, index: true
      t.references :sqw_player, index: true
      t.integer :weight
      t.integer :height
      t.string :shirt_num
      t.float :total_influence
      t.integer :x_loc
      t.integer :y_loc
      t.string :state

      t.timestamps
    end
  end
end
