class RemoveAgeFromSqwPlayer < ActiveRecord::Migration
  def change
      remove_column :sqw_players, :age
  end
end
