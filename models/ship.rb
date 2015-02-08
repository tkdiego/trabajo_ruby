require 'sinatra/activerecord'
class Ship< ActiveRecord::Base
  validates :game_id, presence: true
  validates :player_id, presence: true
  validates :position, presence: true
  
  has_one :game
  has_one :player, :through => :game
  
  def ship_update(id, attacked)
    Ship.update(id, :attacked => attacked)
  end
  
  def enemy_ships_saved(game_id, player_id)
    Player.where.not id:(player_id).ships.where(game_id:game_id, attacked:0)
  end
end

