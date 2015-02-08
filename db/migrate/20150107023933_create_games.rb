class CreateGames < ActiveRecord::Migration
  def change
	 	create_table :games do |t|	
			t.references :creator
			t.references :opponent
			t.integer :table
		end
  end
end
