class SqwFoulsEvent < ActiveRecord::Base
  belongs_to :SqwPlayer
  belongs_to :SqwTeam
end
