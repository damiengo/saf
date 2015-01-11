class CreateSqwTournaments < ActiveRecord::Migration
  def change
    create_table :sqw_tournaments do |t|
      t.string :name
      t.string :country

      t.timestamps
    end
  end
end
