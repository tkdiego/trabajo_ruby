require 'sinatra/activerecord'
class Player< ActiveRecord::Base
  validates :username, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 4 }
  has_many :games

  def authenticate(username, password)
  	(Player.where(username: username, password: password).first).instance_of?(Player)
  end

  def exist?(username)
    !(Player.where username: username).empty?
  end
  
end


