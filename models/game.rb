require 'sinatra/activerecord'
class Game< ActiveRecord::Base
  validates :id_creator, presence: true
  validates :id_opponent, presence: true
  validates :table, presence: true
  validates :turn, presence: true
  
  has_many :ships, dependent: :destroy
  has_many :attacks,  dependent: :destroy
  
  def create_game (id_creator, id_opponent, table, turn)
    Game.create(:id_creator => id_creator, :id_opponent => id_opponent, :table => table, :turn => turn, :players_ready => 0)
  end
  
  def destroy_game_complete
    self.destroy
  end

  def create_ships(player_id, position_ships)
  	for ship in position_ships
   		ships.create(:player_id => player_id, :position => ship[1].to_s, :attacked => 0)
    end
  end

  def update_players_ready (num)
  	update(:players_ready => num)
  end
  
  def game_over?
    self.turn == 0
  end
  
  def bring_ships(player_id)
    ships.where(player_id:player_id)
    
  end
  
  def bring_attacks(player_id)
    attacks.where(player_id:player_id)
  end
  
  def wait_enemy? (player_id)
    self.turn == player_id or self.players_ready != 2
  end
  
  def game_not_exist? (player_id)
    self.id_creator == player_id or self.id_opponent == player_id
  end
  
  def exist_ships?(player_id)
    ships.where(player_id:player_id).length == 0
  end
  
  def turn_player?()
    
  end
end
