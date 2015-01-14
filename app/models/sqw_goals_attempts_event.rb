class SqwGoalsAttemptsEvent < ActiveRecord::Base
  belongs_to :sqw_player
  belongs_to :sqw_game
end
