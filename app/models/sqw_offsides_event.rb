class SqwOffsidesEvent < ActiveRecord::Base
  belongs_to :sqw_player
  belongs_to :sqw_team
  belongs_to :sqw_game
end
