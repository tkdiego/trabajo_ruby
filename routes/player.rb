class Server < Sinatra::Base
  enable :sessions

  get '/' do
  	session_enable
    erb :"player/menu", :layout => :layout
  end

  post '/player' do
    new_player=Player.new
    new_player.username= params[:username]
    new_player.password= params[:password] 
    if !(new_player.exist?(new_player.username)) && new_player.valid?  
      new_player.save
      status 201
      @message="Bienvenido #{new_player.username} ya puede iniciar sesion"
      erb :"player/login", :layout => :layout
    else
      if new_player.exist?(new_player.username)
        status 409
        @message="El usuario ya existe. Error 409"
      else
        status 400
        @message="Usuario o contraseña invalidos. Error 400"  
      end
      erb :"player/sign_in", :layout => :layout
    end     
  end

	get '/login' do
    erb :"player/login", :layout => :layout
	end

  get '/sign_in' do
    erb :"player/sign_in", :layout => :layout
  end
  
	get '/logout' do
		session_logout
	end

  get '/players/?' do
    session_enable
    @list_players = Player.where.not(id: session[:id])
    erb :"player/list", :layout => :layout
  end

  post '/login' do
  	p=Player.find_by username:(params[:username])
    if !(p.nil?) && p.authenticate(p.username,params[:password])
      session[:id] = p.id
      session[:enable] = true
      erb :"player/menu", :layout => :layout
	  else
      status 401
      @message="Usuario o contraseña invalidos. Error 401"
      erb :"player/login", :layout => :layout
	  end
  end
end