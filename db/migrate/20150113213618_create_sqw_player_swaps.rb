class CreateSqwPlayerSwaps < ActiveRecord::Migration
  def change
    create_table :sqw_player_swaps do |t|
      t.integer :min
      t.integer :minsec
      t.references :sub_to_player, index: true
      t.references :player_to_sub, index: true
      t.references :sqw_team, index: true
      t.references :sqw_game, index: true

      t.timestamps
    end
  end
end
