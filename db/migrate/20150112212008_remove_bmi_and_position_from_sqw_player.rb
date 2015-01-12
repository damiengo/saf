class RemoveBmiAndPositionFromSqwPlayer < ActiveRecord::Migration
  def change
      remove_column :sqw_players, :bmi
      remove_column :sqw_players, :position
  end
end
