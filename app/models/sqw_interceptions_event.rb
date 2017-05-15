class SqwInterceptionsEvent < ActiveRecord::Base
  belongs_to :SqwPlayer
  belongs_to :SqwGame
end
