class CreateSqwTeams < ActiveRecord::Migration
  def change
    create_table :sqw_teams do |t|
      t.integer :sqw_id
      t.string :long_name
      t.string :short_name
      t.string :logo
      t.string :shirt_url
      t.string :club_url
      t.string :color

      t.timestamps
    end
  end
end
