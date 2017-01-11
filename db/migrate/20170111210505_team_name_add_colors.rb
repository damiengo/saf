class TeamNameAddColors < ActiveRecord::Migration
  def change
    add_column :team_names, :color1, :string
    add_column :team_names, :color2, :string
  end
end
