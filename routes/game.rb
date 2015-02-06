class Server < Sinatra::Base
	use Rack::MethodOverride 

  # -------- Crear una partida --------
  post '/players/games' do
    session_enable
    opponent=Player.new.find_player(params[:opponent])
    if params[:table].nil? || opponent.nil?  
      halt 400, "Seleccione tabla y oponente" 
    else
      exist_game_with (opponent)
		  @game= Game.new.create_game(session[:id], opponent.id,params[:table], opponent.id)
      status 201
      ships_remaining
		  erb :"game/select_positions"
    end
  end
    
  # -------- Tabla de barcos --------
  get '/players/games/:id_game' do
    session_enable
    game_exist
    @game=Game.find_by_id(params[:id_game])
    ships_remaining
    erb :"game/select_positions"
  end

  # -------- Creacion de los barcos --------
  put '/players/:id/game/:id_game' do
    session_enable
    game_exist
    if params[:left_ships].to_i != 0
      redirect '/players/games/'+params[:id_game]
    end
    @ships_positions=params.select{|h| h!='_method' && h!= 'splat' && h!= 'id' && h!= 'id_game' && h!= 'captures' && h!= 'left_ships'}
#    for ships in @ships_positions
      Ship.new.create_ships(params[:id_game], session[:id], @ships_positions)
#      Ship.create(:game_id => params[:id_game],:player_id => session[:id],:position => ships[1].to_s, :attacked => 0)
#    end
    ready= Game.find_by_id(params[:id_game]).players_ready + 1
    Game.update(params[:id_game],:players_ready => ready)
    redirect '/players/'+ params[:id]+'/games/'+params[:id_game]
  end

  # -------- Ver una partida --------
  get '/players/:id/games/:id_game' do
    session_enable
    game_exist
    if (Ship.where(game_id:params[:id_game],player_id:session[:id])).empty?
      redirect '/players/games/'+ params[:id_game]
    end
    @game= Game.find_by_id(params[:id_game])
    if @game.turn == 0
      destroy_game_complete
      @message = 'Has perdido!'
      erb :"/game/game_over"
    else
      @ships=Ship.where(game_id:params[:id_game],player_id:session[:id])
      @enemy_attacks= Attack.where(game_id:params[:id_game],player_id:session[:id])
      if @game.turn == session[:id] or @game.players_ready != 2
        sleep 1.5
        @turn_player = "Enemigo"
        erb :"game/wait_turn"
      else
        @turn_player = session[:username]
        erb :"game/show_game"
      end 
    end  
  end
  
  # -------- Listar partidas -------
  get '/players/:player_id/games' do
    session_enable
    @list_games=[]
    games= Game.select("games.id_opponent, games.id").joins("INNER JOIN players on games.id_creator = players.id").where("players.id == #{session[:id]} and games.id_opponent != #{session[:id]}")
    for game in games
      player = Player.find_by_id(game.id_opponent)
      @list_games << [player.username, game.id]
    end
    games= Game.select("games.id_creator, games.id").joins("INNER JOIN players on games.id_opponent = players.id").where("players.id == #{session[:id]} and games.id_creator != #{session[:id]}")
    for game in games
      player = Player.find_by_id(game.id_creator)
      @list_games << [player.username, game.id]
    end
    erb :"/game/list_games"
  end
  
  #-------- Hacer una jugada --------
  post '/player/:player_id/games/:id_game/move' do
    session_enable
    game_turn_player
    ship= Ship.where("ships.game_id == #{params[:id_game]} AND ships.player_id != #{session[:id]} AND ships.position == '#{params[:attack].to_s}'")
    #   Se actualiza el barco como atacado para luego mostrar en el mapa.
    if ship.empty?
      Attack.create_attack(session[:id], params[:id_game], params[:attack].to_s, "miss")
    else
      Attack.create_attack(session[:id], params[:id_game], params[:attack].to_s, "throw")
      Ship.ship_update(ship.last.id, 1)
    end  
    status 201
    if enemy_ships_saved(params[:id_game], session[:id]).empty?
      Game.update(params[:id_game],:turn => 0)
      @message= "Has ganado!"
      erb :"/game/game_over"
    else
      idPlayer= session[:id].to_s
      Game.update(params[:id_game],:turn => session[:id])
      redirect '/players/'+ idPlayer +'/games/' + params[:id_game] 
    end
  end
  
  get '/esperar/:id/games/:id_game' do
    @game= Game.find_by_id(params[:id_game])
    if @game.turn == session[:id]
      sleep 1
    end
    idPlayer= session[:id].to_s
    redirect '/players/' + idPlayer + '/games/' + params[:id_game]
  end

end