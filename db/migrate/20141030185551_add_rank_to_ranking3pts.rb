class AddRankToRanking3pts < ActiveRecord::Migration
  def change
    add_column :ranking3pts, :rank, :integer
  end
end
