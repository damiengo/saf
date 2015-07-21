class CreateSqwAllPassesEvents < ActiveRecord::Migration
  def change
    create_table :sqw_all_passes_events do |t|
      t.references :sqw_player, index: true
      t.references :sqw_team, index: true
      t.float :start_x
      t.float :start_y
      t.float :end_x
      t.float :end_y
      t.string :type
      t.integer :mins
      t.integer :secs
      t.integer :minsec
      t.boolean :throw_in
      t.boolean :assist
      t.boolean :long_ball
      t.boolean :through_ball
      t.boolean :headed

      t.timestamps
    end
  end
end
