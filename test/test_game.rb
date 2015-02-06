ENV['RACK_ENV'] = 'test'

require './server'
require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

class TestPlayer < MiniTest::Test

  include Rack::Test::Methods

  def app
    Server
  end

  def test_db_start
    DatabaseCleaner.start
  end

  def test_valid_list_games
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    get '/players/'+user1.id.to_s+'/games', {}, 'rack.session' => { :id => user1.id, :username => user1.username, :enable => true }
    assert_equal 200, last_response.status
  end

  def test_create_game_with_repeat_opponent
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    post '/players/games', {:opponent => user2.username, :table => 5 }, 'rack.session' => { :id => 1, :username => "user1", :enable => true }
    assert_equal 409, last_response.status
    assert last_response.body.include?("Ya ha iniciado una partida con el rival seleccionado")
  end

  def test_invalid_create_game
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    post '/players/games', {:opponent => user2.username}, 'rack.session' => { :id => user1.id, :username => user1.username, :enable => true }
    assert_equal 400, last_response.status
    assert last_response.body.include?("Seleccione tabla y oponente")
  end

  def test_valid_create_game 
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    post '/players/games', {:opponent => user2.username, :table => 5 }, 'rack.session' => { :id =>user1.id, :username => user1.username, :enable => true }
    assert_equal 201, last_response.status
  end

  def test_valid_move
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    game= Game.create(:id_creator => user1.id, :id_opponent => user2.id, :table => 5, :turn => user2.id, :players_ready => 2)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:1', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:2', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:3', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '1:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '2:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '3:0', :attacked => 0)

    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:1', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:2', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:3', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '1:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '2:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '3:0', :attacked => 0)
    post '/player/'+user1.id.to_s+'/games/'+game.id.to_s+'/move', {:attack => "0:0"}, 'rack.session' => { :id => user1.id, :username => user1.username, :enable => true }
    assert_equal 201, last_response.status
  end

  def test_invalid_move_turn_enemy
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    game= Game.create(:id_creator => user1.id, :id_opponent => user2.id, :table => 5, :turn => user2.id, :players_ready => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:1', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:2', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:3', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '1:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '2:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '3:0', :attacked => 0)

    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:1', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:2', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:3', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '1:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '2:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '3:0', :attacked => 0)
    post '/player/'+user2.id.to_s+'/games/'+game.id.to_s+'/move', {:attack => "0:0", :id_game => game.id}, 'rack.session' => { :id => user2.id, :username => user2.username, :enable => true }
    assert_equal 403, last_response.status
    assert last_response.body.include?("403 Forbidden: Turno del rival.")
  end

  def test_invalid_move_attack_nil
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    game= Game.create(:id_creator => user1.id, :id_opponent => user2.id, :table => 5, :turn => user2.id, :players_ready => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:1', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:2', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '0:3', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '1:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '2:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user1.id,:position => '3:0', :attacked => 0)

    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:1', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:2', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '0:3', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '1:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '2:0', :attacked => 0)
    Ship.create(:id_game => game.id,:id_player => user2.id,:position => '3:0', :attacked => 0)
    post '/player/'+user1.id.to_s+'/games/'+game.id.to_s+'/move', { :id_game => game.id}, 'rack.session' => { :id => user1.id, :username => user1.username, :enable => true }
    assert_equal 400, last_response.status
    assert last_response.body.include?("400 Bad request: No se ha especificado el ataque")
  end
  
  def test_db_clean
    DatabaseCleaner.clean
  end

end
