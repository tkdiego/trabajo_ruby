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

  def create_valid_user
    Player.create(:username => 'user',:password => 'user')
  end

  def test_valid_sign_in
    post '/player', :username => 'new_user_'+rand(1000).to_s, :password => 'nuevo'
    assert_equal 201, last_response.status
    assert last_response.body.include?("Bienvenido")
  end

  def test_invalid_sign_in
    post '/player', :username => '', :password => ''
    assert_equal 400, last_response.status
    assert last_response.body.include?("Usuario o contraseña invalidos")
  end

  def test_user_exist_sign_in
    create_valid_user
    post '/player', :username => 'user', :password => 'user'
    assert_equal 409, last_response.status
    assert last_response.body.include?("El usuario ya existe")
  end

  def test_valid_login
    create_valid_user
    post '/login',:username => 'user', :password => 'user'
    assert_equal 200, last_response.status
  end

  def test_invalid_login
    post '/login',:username => 'invalid_user', :password => 'invalid_pass'
    assert_equal 401, last_response.status
    assert last_response.body.include?("Usuario o contraseña invalidos")
  end
  
  def test_list_players
    get '/players/1/games',{}, 'rack.session' => { :id => 1, :username => "user", :enable => true }
    assert_equal 200, last_response.status
  end
  
  def test_db_clean
    DatabaseCleaner.clean
  end
  
end