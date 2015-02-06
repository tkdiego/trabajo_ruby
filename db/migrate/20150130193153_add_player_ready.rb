class AddPlayerReady < ActiveRecord::Migration
  def change
    add_column(:games,:players_ready,:integer)
  end
end
