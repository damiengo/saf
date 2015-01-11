class CreateSqwSeasons < ActiveRecord::Migration
  def change
    create_table :sqw_seasons do |t|
      t.integer :start
      t.integer :end

      t.timestamps
    end
  end
end
