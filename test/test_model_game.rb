
class TestModelGame < MiniTest::Test
  include Rack::Test::Methods
  
  def app
    Server
  end
  
  def test_valid_create_game
    game = Game.new
    game.create_game(1,2,5,2)
    game_db= Game.find_by id:(game.id)
    assert game_db == game
  end
  
  def test_invalid_create_game
    game = Game.new
    assert_raises(ArgumentError) {game.create_game(1,2)}
  end
  
  def test_valid_create_ships
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert game.ships.where(player_id:1).length == 7
  end
  
  def test_invalid_create_ships
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert game.ships.where(player_id:1).length != 7
  end
  
  def test_valid_update_player_ready
    game = Game.new
    game.create_game(1,2,5,2)
    game.update_players_ready(1)
    assert game.players_ready == 1
  end
  
  def test_invalid_update_player_ready
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises(ArgumentError) {game.update_players_ready}
  end
  
  def test_valid_exist_game_between
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.exist_game_between(1,2) == true
  end
  
  def test_invalid_exist_game_between
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.exist_game_between(1,3) == false
  end
  
  def test_valid_ship_remaining
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.ships_remaining == 7
  end
  
  def test_invalid_ship_remaining
    game = Game.new
    game.create_game(1,2,10,2)
    assert game.ships_remaining != 7
  end
  
  def test_valid_game_over
    game = Game.new
    game.create_game(1,2,10,0)
    assert game.game_over?
  end
  
  def test_invalid_game_over
    game = Game.new
    game.create_game(1,2,10,2)
    assert game.game_over? == false
  end
  
  def test_valid_bring_ships
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert game.bring_ships(1).length == 7
  end
  
  def test_invalid_bring_ships
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert game.bring_ships(2).length != 7
  end
  
  def test_valid_bring_attacks
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_attack(1,"0:0","miss")
    assert game.bring_attacks(1).length > 0
  end
  
  def test_invalid_bring_attacks
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_attack(1,"0:0","miss")
    assert game.bring_attacks(2).length == 0
  end
  
  def test_valid_wait_enemy
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.wait_enemy?(1)  
  end
  
  def test_invalid_wait_enemy
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises(ArgumentError){game.wait_enemy?} 
  end
  
  def test_valid_game_exist_for_player
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.game_exist_for_player?(1)
    assert game.game_exist_for_player?(2)
  end
  
  def test_invalid_game_exist_for_player
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises(ArgumentError){game.game_exist_for_player?}
  end
  
  def test_valid_not_exist_ships
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.not_exist_ships?(1)
  end
  
  def test_invalid_not_exist_ships
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises (ArgumentError) {game.not_exist_ships?}
  end
  
  def test_valid_not_turn_player
    game = Game.new
    game.create_game(1,2,5,2)
    assert game.not_turn_player?(2)
  end
  
  def test_invalid_not_turn_player
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises (ArgumentError) {game.not_turn_player?}
  end
  
  def test_valid_enemy_ship
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert game.enemy_ship(2,"0:0").length == 1
  end
  
  def test_invalid_enemy_ship
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert_raises (ArgumentError) {game.enemy_ship("0:0").length == 1}
  end
    
  def test_valid_model_create_attack
    game = Game.new
    game.create_game(1,2,5,2)
    attack= game.create_attack(1,"0:0","miss")
    attack_db = Attack.find_by id:(attack.id)
    assert attack == attack_db
  end
  
  def test_invalid_model_create_attack
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises (ArgumentError) {game.create_attack(1,"miss")}
  end
  
  def test_valid_enemy_ships_saved
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert game.enemy_ships_saved?(2)
  end
  
  def test_invalid_enemy_ships_saved
    ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
    game = Game.new
    game.create_game(1,2,5,2)
    game.create_ships(1,ships)
    assert_raises (ArgumentError) {game.enemy_ships_saved?}
  end
  
  def test_valid_update_turn
    game = Game.new
    game.create_game(1,2,5,2)
    game.update_turn(1)
    assert game.turn == 1
  end
  
  def test_invalid_update_turn
    game = Game.new
    game.create_game(1,2,5,2)
    assert_raises (ArgumentError) {game.update_turn}
  end
  
end