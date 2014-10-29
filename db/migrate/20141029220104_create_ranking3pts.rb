class CreateRanking3pts < ActiveRecord::Migration
  def change
    create_table :ranking3pts do |t|
      t.references :season, index: true
      t.integer :day
      t.references :team, index: true
      t.integer :points
      t.integer :wins
      t.integer :draws
      t.integer :losts
      t.integer :goals_for
      t.integer :goals_against

      t.timestamps
    end
  end
end
