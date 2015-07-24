class AddIndexToMinsecSqwAllPassesEvents < ActiveRecord::Migration
  def change
    add_index :sqw_all_passes_events, :minsec
  end
end
