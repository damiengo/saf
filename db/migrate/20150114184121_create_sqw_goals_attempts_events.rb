class CreateSqwGoalsAttemptsEvents < ActiveRecord::Migration
  def change
    create_table :sqw_goals_attempts_events do |t|
      t.string :event_type
      t.references :sqw_player, index: true
      t.references :sqw_game, index: true
      t.string :action_type
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.float :start_x
      t.float :start_y
      t.float :end_x
      t.float :end_y
      t.float :gmouth_y
      t.float :gmouth_z
      t.boolean :headed

      t.timestamps
    end
  end
end
