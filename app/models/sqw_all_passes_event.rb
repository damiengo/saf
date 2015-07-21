class SqwAllPassesEvent < ActiveRecord::Base
  belongs_to :sqw_player
  belongs_to :sqw_team
end
