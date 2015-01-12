class SqwPlayerGame < ActiveRecord::Base
  belongs_to :sqw_game
  belongs_to :sqw_player
end
