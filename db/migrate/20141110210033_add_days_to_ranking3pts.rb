class AddDaysToRanking3pts < ActiveRecord::Migration
  def change
    add_column :ranking3pts, :days, :integer
  end
end
