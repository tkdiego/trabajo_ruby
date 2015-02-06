class CreateShips < ActiveRecord::Migration
  def change
 	create_table :ships do |t|	
    t.belongs_to :game, index: true
    t.belongs_to :player, index: true
		t.integer :game_id
		t.integer :player_id
		t.string :position
	end	
  end
end
