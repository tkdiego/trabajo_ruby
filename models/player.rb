require 'sinatra/activerecord'
class Player< ActiveRecord::Base
  validates :username, presence: true, length: { maximum: 30 }
  validates :password, presence: true, length: { minimum: 4 }
  has_many :games

  def exist?(username)
    !(Player.where username: username).empty?
  end
end


