require 'sinatra/activerecord'
class Attack< ActiveRecord::Base
  validates :id_game, presence: true
  validates :id_player, presence: true
  validates :position, presence: true
  validates :state, presence: true
  
  def create_attack(player_id, game_id, position, state)
#    Attack.create(:player_id => player_id, :game_id => game_id, :position => position, :state => state)
     Player.find_by id:(player_id).attacks.create(game_id: game_id, position: position, state: state)
  end
  
end