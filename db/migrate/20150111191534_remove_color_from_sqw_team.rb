class RemoveColorFromSqwTeam < ActiveRecord::Migration
  def change
      remove_column :SqwTeam, :color
  end
end
