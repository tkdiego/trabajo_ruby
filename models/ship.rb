require 'sinatra/activerecord'
class Ship< ActiveRecord::Base
  validates :id_game, presence: true
  validates :id_player, presence: true
  validates :position, presence: true
  
  has_one :game
  has_one :player, :through => :game
  
  def ship_update(id, attacked)
     Ship.update(id, :attacked => attacked)
  end
  
  def enemy_ships_saved(game_id, player_id)
    Player.where.not id:(player_id).ships.where(game_id:game_id, attacked:0)
  end
  
  def create_ships(game_id, player_id, position_ships)
    game = Game.find_by id:(game_id)
    for ship in position_ships
#      Ship.create(:game_id => params[:id_game],:player_id => session[:id],:position => ships[1].to_s, :attacked => 0)
       game.ships.create(:player_id => player_id, :position => ship[1].to_s, :attacked => 0)
    end
  end
end
