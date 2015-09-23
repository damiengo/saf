class AddIndexToEloRatings < ActiveRecord::Migration
  def change
    add_index :elo_ratings, :date_of_update
    add_index :elo_ratings, :team
    add_index :elo_ratings, :country
    add_index :elo_ratings, :level
    add_index :elo_ratings, :elo
  end
end
