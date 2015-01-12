class CreateSqwGames < ActiveRecord::Migration
  def change
    create_table :sqw_games do |t|
      t.datetime :kickoff
      t.string :venue
      t.integer :home_goals
      t.integer :away_goals
      t.references :sqw_home_team, index: true
      t.references :sqw_away_team, index: true
      t.references :sqw_season, index: true
      t.references :sqw_tournament, index: true

      t.timestamps
    end
  end
end
