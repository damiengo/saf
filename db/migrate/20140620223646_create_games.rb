class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_goals
      t.integer :away_goals
      t.integer :day
      t.references :home_team, index: true
      t.references :away_team, index: true
      t.references :tournament, index: true
      t.references :season, index: true

      t.timestamps
    end
  end
end
