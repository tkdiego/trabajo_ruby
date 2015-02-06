class CreateAttacks < ActiveRecord::Migration
  def change
    create_table :attacks do |t|	
      t.belongs_to :game, index: true
      t.belongs_to :player, index: true
			t.integer :player_id
			t.integer :game_id
			t.string :position
      t.string :state
		end
  end
end