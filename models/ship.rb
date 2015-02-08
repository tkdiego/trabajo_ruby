require 'sinatra/activerecord'
class Ship< ActiveRecord::Base
  validates :game_id, presence: true
  validates :player_id, presence: true
  validates :position, presence: true
  
  has_one :game
  has_one :player, :through => :game
  
  def is_attacked
    self.update(:attacked => 1)
  end
end