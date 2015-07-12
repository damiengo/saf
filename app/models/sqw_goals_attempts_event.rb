class SqwGoalsAttemptsEvent < ActiveRecord::Base
  belongs_to :sqw_player
  belongs_to :sqw_game
  has_many :sqw_goals_passlinks
end
