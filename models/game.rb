require 'sinatra/activerecord'
class Game< ActiveRecord::Base
  validates :id_creator, presence: true
  validates :id_opponent, presence: true
  validates :table, presence: true
  validates :turn, presence: true
  
  has_many :ships, dependent: :destroy
  has_many :attacks,  dependent: :destroy
  
  def create_game (id_creator, id_opponent, table, turn)
    self.id_creator=id_creator
    self.id_opponent=id_opponent
    self.table=table 
    self.turn=turn 
    self.players_ready=0
    self.save  
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
    games_as_creator= Game.where(id_opponent:opponent.id, id_creator:creator.id)
    games_as_opponent= Game.where(id_opponent:creator.id, id_creator:opponent.id)
    return !(games_as_creator.empty? && games_as_opponent.empty?)
  end

  def ships_remaining (table_size)
    case table_size
    when 5
      return 7
    when 10
      return 15
    else
      return 20
    end
  end

end
