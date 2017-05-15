class CreateSqwInterceptions < ActiveRecord::Migration
  def change
    create_table :sqw_interceptions do |t|
      t.references :sqw_player, index: true
      t.references :sqw_game, index: true
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.string :action_type
      t.integer :loc_x
      t.integer :loc_y

      t.timestamps
    end
  end
end
