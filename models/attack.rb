require 'sinatra/activerecord'
class Attack< ActiveRecord::Base
  validates :game_id, presence: true
  validates :player_id, presence: true
  validates :position, presence: true
  validates :state, presence: true
  
end