class CreateEloRatings < ActiveRecord::Migration
  def change
    create_table :elo_ratings do |t|
      t.string :team
      t.string :country
      t.integer :level
      t.float :elo
      t.date :from
      t.date :to
      t.date :date_of_update

      t.timestamps
    end
  end
end
