class CreateSqwPlayers < ActiveRecord::Migration
  def change
    create_table :sqw_players do |t|
      t.integer :sqw_id
      t.string :first_name
      t.string :last_name
      t.string :name
      t.string :surname
      t.string :photo
      t.string :position
      t.date :dob
      t.string :country
      t.integer :age
      t.float :bmi
      t.references :sqw_team, index: true

      t.timestamps
    end
  end
end
