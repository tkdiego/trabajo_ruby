class Server < Sinatra::Base
  enable :sessions

  get '/' do
  	session_enable
    erb :"player/menu"
  end

  post '/player' do
    user = params[:username]
    pass= params[:password] 
    user_exist=!(Player.where("players.username == '#{user}'").empty?)
    if  !(user_exist) && Player.create(:username => user,:password => pass).valid? 
        status 201
        @message="Bienvenido " + params[:username] + " ya puede iniciar sesion"
        erb :"player/login"
    else
      if user_exist
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
  	p=Player.find_by_username(params[:username])
	  if (!(p.nil?) && (p.password== params[:password]) ) then
      session[:id] = p.id
      session[:username] = p.username
      session[:enable] = true
      erb :"player/menu"
	  else
      status 401
      @message="Usuario o contraseña invalidos"
      erb :"player/login"
	  end
  end
end