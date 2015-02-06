class Server < Sinatra::Base
  enable :sessions

  get '/' do
  	session_enable
    erb :"player/menu"
  end

  post '/player' do
    new_player=Player.new
    new_player.username= params[:username]
    new_player.password= params[:password] 
    if !(new_player.exist?(new_player.username)) && new_player.valid?  
        new_player.save
        status 201
        @message="Bienvenido #{new_player.username} ya puede iniciar sesion"
        erb :"player/login"
    else
      if new_player.exist?(new_player.username)
        status 409
        @message="El usuario ya existe"
        erb :"player/sign_in"
      else
        status 400
        @message="Usuario o contraseña invalidos"
        erb :"player/sign_in"
      end
    end
  end

	get '/login' do
    erb :"player/login"
	end

  get '/sign_in' do
    erb :"player/sign_in"
  end
  
	get '/logout' do
		session_logout
	end

  get '/players/?' do
    session_enable
  	@list_players = Player.where("players.id != #{session[:id]}")
    erb :"player/list"
  end

  post '/login' do
  	p=Player.find_by username:(params[:username])
	  if (!(p.nil?) && (p.password== params[:password]) ) then
      session[:id] = p.id
      session[:username] = p.username
      erb :"player/menu"
	  else
      status 401
      @message="Usuario o contraseña invalidos"
      erb :"player/login"
	  end
  end
end