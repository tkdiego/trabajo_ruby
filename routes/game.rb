class Server < Sinatra::Base
	use Rack::MethodOverride 

  # -------- Crear una partida --------
  post '/players/games' do
    session_enable
    opponent=Player.find_by username:(params[:opponent])
    creator= Player.find_by id:(session[:id])
    @game=Game.new
    if @game.exist_game_between(creator, opponent)
      @message="Ya ha iniciado una partida con el rival seleccionado"
      @list_players = Player.where.not(id: session[:id])
      erb :"player/list"
    else
      @game.create_game(session[:id], opponent.id, params[:table], opponent.id)
      @ships_remaining=@game.ships_remaining(@game.table)
      status 201
      erb :"game/select_positions"
    end
  end
    
  # -------- Tabla de barcos --------
  get '/players/games/:id_game' do
    session_enable
    if @game.game_not_exist_for_player?(session[:id])
      status 400
#      hacer un mensaje de que no existe
    end
    @game=Game.find_by_id(params[:id_game])
    ships_remaining#VA EN EL MODELO
    erb :"game/select_positions"
  end

  # -------- Creacion de los barcos --------
  put '/players/:id/game/:id_game' do
    session_enable
    game = Game.find_by id: params[:id_game]
    game_exist
    if params[:left_ships].to_i != 0
      redirect '/players/games/'+params[:id_game]
    end
    @ships_positions=params.select{|h| h!='_method' && h!= 'splat' && h!= 'id' && h!= 'id_game' && h!= 'captures' && h!= 'left_ships'}
    game.create_ships(session[:id], @ships_positions)
    game.update_players_ready(game.players_ready + 1)
    redirect '/players/'+ params[:id]+'/games/'+params[:id_game]
  end

  # -------- Ver una partida --------
  get '/players/:id/games/:id_game' do
    session_enable
    @game= Game.find_by_id(params[:id_game])
    if @game.game_not_exist?(session[:id])
      status 400
#      hacer un mensaje de que no existe
    end
    if (@game.exist_ships?(session[:id]))
      redirect '/players/games/'+ params[:id_game]
    end
    if @game.game_over?
      @game.destroy_game_complete
      @message = 'Has perdido!'
      erb :"/game/game_over"
    else
      @ships = @game.bring_ships(session[:id])
      @enemy_attacks = @game.bring_attacks(session[:id])
      if @game.wait_enemy?(session[:id])
        sleep 1.5
        @turn_player = "Enemigo"
        erb :"game/wait_turn"
      else
        @turn_player = Player.find_by id:(session[:id])
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
      Attack.new.create_attack(session[:id], params[:id_game], params[:attack].to_s, "miss")
    else
      Attack.new.create_attack(session[:id], params[:id_game], params[:attack].to_s, "throw")
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