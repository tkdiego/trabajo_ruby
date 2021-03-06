require 'sinatra/activerecord'
class Game< ActiveRecord::Base
  validates :creator_id, presence: true
  validates :opponent_id, presence: true
  validates :table, presence: true
  validates :turn, presence: true
  
  has_many :ships, dependent: :destroy
  has_many :attacks,  dependent: :destroy
  has_one :opponent, :class_name => 'Player'
  has_one :creator, :class_name => 'Player'

  def create_game (creator_id, opponent_id, table, turn)
    self.creator_id=creator_id
    self.opponent_id=opponent_id
    self.table=table 
    self.turn=turn 
    self.players_ready=0
    self.save  
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

  def exist_game_between(creator, opponent)
    games_as_creator= Game.where(opponent_id:opponent, creator_id:creator)
    games_as_opponent= Game.where(opponent_id:creator, creator_id:opponent)
    !(games_as_creator.empty? && games_as_opponent.empty?)
  end

  def ships_remaining
    case self.table
    when 5
      7
    when 10
      15
    else
      20
    end
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
  
  def game_exist_for_player? (player_id)
    self.creator_id == player_id or self.opponent_id == player_id
  end
  
  def not_exist_ships?(player_id)
    ships.where(player_id:player_id).length == 0
  end
  
  def not_turn_player?(player_id)
    self.turn == player_id
  end
  
  def enemy_ship(player, attack)
    ships.where.not(player_id:player).where(position:attack)
  end
  
  def create_attack(player_id, attack,state)
    attacks.create(:player_id => player_id, :position => attack, :state => state)
  end

  def enemy_ships_saved?(player_id)
    ships.where.not(player_id:player_id).where(attacked:0).length > 0
  end
  
  def update_turn(num)
    self.update(:turn => num) 
  end
  
end
