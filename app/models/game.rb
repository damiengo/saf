class Game < ActiveRecord::Base
  belongs_to :home_team
  belongs_to :away_team
  belongs_to :tournament
  belongs_to :season
end
