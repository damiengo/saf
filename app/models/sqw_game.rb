class SqwGame < ActiveRecord::Base
  belongs_to :sqw_home_team, :class_name => 'SqwTeam'
  belongs_to :sqw_away_team, :class_name => 'SqwTeam'
  belongs_to :sqw_season
  belongs_to :sqw_tournament
end
