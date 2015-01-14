class AddMinsecToSqwHeadedDualsEvent < ActiveRecord::Migration
  def change
    add_column :sqw_headed_duals_events, :minsec, :integer
  end
end
