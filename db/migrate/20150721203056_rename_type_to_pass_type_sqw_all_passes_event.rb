class RenameTypeToPassTypeSqwAllPassesEvent < ActiveRecord::Migration
  def change
    rename_column :sqw_all_passes_events, :type, :pass_type
  end
end
