require 'sinatra/activerecord'
class Player< ActiveRecord::Base
  validates :username, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 4 }
  has_many :games
  has_many :ships , through: :games
  has_many :attacks, through: :games

  def authenticate(username, password)
   !(Player.where(username: username, password: password).first).nil?
  end

  def exist?(username)
    !(Player.where username: username).empty?
  end
  
  def find_player(enemy)
    Player.find_by_username(enemy)
  end

end

  
