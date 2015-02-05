require 'sinatra/activerecord'
class Attack< ActiveRecord::Base
  validates :id_game, presence: true
  validates :id_player, presence: true
  validates :position, presence: true
  validates :state, presence: true
end