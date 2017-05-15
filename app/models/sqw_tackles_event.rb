class SqwTacklesEvent < ActiveRecord::Base
  belongs_to :sqw_player
  belongs_to :sqw_game
  belongs_to :sqw_team
end
