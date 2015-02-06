class AddAttacked < ActiveRecord::Migration
  def change
    add_column(:ships,:attacked,:integer)
  end
end
