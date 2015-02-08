require 'sinatra/activerecord'
class Player< ActiveRecord::Base
  validates :username, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 4 }
  has_many :games_as_creator,  class_name: 'Game',:foreign_key => 'creator_id'
  has_many :games_as_opponent, class_name: 'Game',:foreign_key => 'opponent_id'
  has_many :ships , through: :games
  has_many :attacks, through: :games

  def authenticate(username, password)
  	(Player.where(username: username, password: password).first).instance_of?(Player)
  end

  def exist?(username)
    !(Player.where username: username).empty?
  end

  def get_games_as_creator
    self.games_as_creator
  end

  def get_games_as_opponent
    self.games_as_opponent
  end
end

  
