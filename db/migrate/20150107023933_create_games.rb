class CreateGames < ActiveRecord::Migration
  def change
	 	create_table :games do |t|	
			t.integer :id_creator
			t.integer :id_opponent
			t.integer :table
		end
  end
end
