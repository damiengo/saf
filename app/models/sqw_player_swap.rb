class SqwPlayerSwap < ActiveRecord::Base
  belongs_to :sub_to_player, :class_name => 'SqwPlayer'
  belongs_to :player_to_sub, :class_name => 'SqwPlayer'
  belongs_to :sqw_team
  belongs_to :sqw_game
end
