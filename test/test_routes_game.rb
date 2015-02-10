class TestPlayer < MiniTest::Test

  include Rack::Test::Methods

  def app
    Server
  end

  def load_data
    @user1= Player.create(:username => 'user1',:password => 'user1')
    @user2= Player.create(:username => 'user2',:password => 'user2')
    @game = Game.create(:creator_id => @user1.id, :opponent_id => @user2.id, :table => 5, :turn => @user2.id, :players_ready => 2)
    @ships = [[:"0:0","0:0"], [:"0:1" , "0:1"],[ :"0:2" , "0:2"], [:"0:3" , "0:3"],[ :"0:4", "0:4"],[ :"1:0", "1:0"],[ :"2:0", "2:0"]]
  end

  def test_valid_list_games
    load_data
    get '/players/'+@user1.id.to_s+'/games', {}, 'rack.session' => { :id => @user1.id, :enable => true }
    assert_equal 200, last_response.status
  end

  def test_create_game_with_repeat_opponent
    load_data
    post '/players/games', {:opponent => @user2.username, :table => 5 }, 'rack.session' => { :id => @user1.id, :enable => true }
    assert_equal 409, last_response.status
    assert last_response.body.include?("Ya ha iniciado una partida con el rival seleccionado")
  end

  def test_invalid_create_game
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    post '/players/games', {:opponent => user2.username}, 'rack.session' => { :id => user1.id, :enable => true }
    assert_equal 400, last_response.status
    assert last_response.body.include?("400, Bad request: Seleccione oponente y tamaño de tabla")
  end

  def test_valid_create_game 
    user1= Player.create(:username => 'user1',:password => 'user1')
    user2= Player.create(:username => 'user2',:password => 'user2')
    post '/players/games', {:opponent => user2.username, :table => 5 }, 'rack.session' => { :id =>user1.id, :enable => true }
    assert_equal 201, last_response.status
  end

 def test_valid_move
    load_data
    @game.create_ships(@user1.id,@ships)
    post '/player/'+@user1.id.to_s+'/games/'+@game.id.to_s+'/move', {:attack => "0:0"}, 'rack.session' => { :id => @user1.id, :enable => true }
    assert_equal 201, last_response.status
  end

  def test_invalid_move_turn_enemy
    load_data
    @game.create_ships(@user2.id,@ships)
    post '/player/'+@user2.id.to_s+'/games/'+@game.id.to_s+'/move', {:attack => "0:0", :game_id => @game.id}, 'rack.session' => { :id => @user2.id, :enable => true }
    assert_equal 403, last_response.status
    assert last_response.body.include?("403 Forbidden: Turno del rival.")
  end

end
