class CreateAttacks < ActiveRecord::Migration
  def change
    create_table :attacks do |t|	
			t.integer :id_player
			t.integer :id_game
			t.string :position
      t.string :state
		end
  end
end