class SqwHeadedDualsEvent < ActiveRecord::Base
  belongs_to :sqw_player
  belongs_to :sqw_game
  belongs_to :otherplayer, :class_name => 'SqwPlayer'
end
