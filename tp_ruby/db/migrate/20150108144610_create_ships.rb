class CreateShips < ActiveRecord::Migration
  def change
 	create_table :ships do |t|	
		t.integer :id_game
		t.integer :id_player
		t.string :position
	end	
  end
end
