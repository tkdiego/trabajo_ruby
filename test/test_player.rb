class TestPlayer < MiniTest::Test

  include Rack::Test::Methods

  def app
    Server
  end

  def create_user
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
    user=create_user
    post '/player', :username => user.username, :password => user.password
    assert_equal 409, last_response.status
    assert last_response.body.include?("El usuario ya existe")
  end

  def test_valid_login
    user=create_user
    post '/login',:username => user.username, :password => user.password
    assert_equal 200, last_response.status
  end

  def test_invalid_login
    post '/login',:username => 'invalid_user', :password => 'invalid_pass'
    assert_equal 401, last_response.status
    assert last_response.body.include?("Usuario o contraseña invalidos")
  end
  
  def test_list_players
    user=create_user
    get '/players/'+user.id.to_s,{}, 'rack.session' => { :id => user.id, :enable => true }
    assert_equal 200, last_response.status
  end
  
end