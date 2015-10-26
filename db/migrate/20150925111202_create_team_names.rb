class CreateTeamNames < ActiveRecord::Migration
  def change
    create_table :team_names do |t|
      t.string :abbr
      t.string :elo
      t.string :sqw
      t.string :lfp

      t.timestamps
    end
  end
end
