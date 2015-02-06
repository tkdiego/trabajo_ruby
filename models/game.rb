require 'sinatra/activerecord'
class Game< ActiveRecord::Base
  validates :id_creator, presence: true
  validates :id_opponent, presence: true
  validates :table, presence: true
  validates :turn, presence: true
  
  has_many :ships, dependent: :destroy
  has_many :attacks,  dependent: :destroy
  has_one :player
end
