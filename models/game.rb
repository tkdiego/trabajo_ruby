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
end
