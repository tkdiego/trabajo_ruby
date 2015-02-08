require 'sinatra/activerecord'
class Attack< ActiveRecord::Base
  validates :game_id, presence: true
  validates :player_id, presence: true
  validates :position, presence: true
  validates :state, presence: true
  
  def create_attack(player_id, attack, state)
     self.create(:player_id => player_id, :position => attack, :state => state)
  end
end