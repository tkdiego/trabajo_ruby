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
      status 409
      erb :"player/list", :layout => :layout
    else
      @game.create_game(session[:id], opponent.id, params[:table], opponent.id)
      status 201
      erb :"game/select_positions", :layout => :layout
    end
  end
    
  # -------- Seleccionar posicion de los barcos --------
  get '/players/games/:id_game' do
    session_enable
    @game=Game.find_by_id(params[:id_game])
    if @game.game_not_exist_for_player?(session[:id])
      status 400
      @message= "400, Bad request: No participa en la partida"
      @url= '/'
      @msj_url= "Volver al menu"
      erb :error, :layout => :layout
    end
    @ships_remaining= @game.ships_remaining(@game.table)
    erb :"game/select_positions",:layout => :layout
  end

  # -------- Creacion de los barcos --------
  put '/players/:id/game/:id_game' do
    session_enable
    game = Game.find_by id: params[:id_game]
    if game.game_not_exist_for_player?(session[:id])
      status 400
      #      hacer un mensaje de que no existe
    end
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
    if @game.game_not_exist_for_player?(session[:id])
      @message= "400, Bad request: No participa en la partida"
      @url= '/'
      @msj_url= "Volver al menu"
      erb :error, :layout => :layout
    end
    if (@game.exist_ships?(session[:id]))
      redirect '/players/games/'+ params[:id_game]
    end
    if @game.game_over?
      @game.destroy_game_complete
      @message = 'Has perdido!'
      erb :"/game/game_over", :layout => :layout
    else
      @ships = @game.bring_ships(session[:id])
      @enemy_attacks = @game.bring_attacks(session[:id])
      if @game.wait_enemy?(session[:id])
        sleep 1.5
        @turn_player = "Enemigo"
        erb :"game/wait_turn"
      else
        @turn_player = Player.find_by id:(session[:id])
        erb :"game/show_game", :layout => :layout
      end 
    end  
  end
  
  # -------- Listar partidas -------
  get '/players/:player_id/games' do
    session_enable
    @list_games=[]
    games=(Player.find_by id:(session[:id])).get_games_as_creator
    for game in games
      player = Player.find_by_id(game.opponent_id)
      @list_games << [player.username, game.id]
    end
    games=(Player.find_by id:(session[:id])).get_games_as_opponent
    for game in games
      player = Player.find_by_id(game.creator_id)
      @list_games << [player.username, game.id]
    end
    erb :"/game/list_games", :layout => :layout
  end
  
  #-------- Hacer una jugada --------
  post '/player/:player_id/games/:id_game/move' do
    session_enable
    game = Game.find_by id: params[:id_game]
    if game.game_not_exist_for_player?(session[:id])
      status 400
      @message= "400, Bad request: No participa en la partida"
      @url= '/'
      @msj_url= "Volver al menu"
      erb :error, :layout => :layout
    end
    if game.not_turn_player?(session[:id])
      status 403
      @message= "400 Forbidden: Turno del rival."
      @url= '/players'+ session[:id]+'/games'+ params[:id_game]
      @msj_url= "Volver"
      erb :error, :layout => :layout
    end
    if params[:attack] == nil
      status 400
      @message= "400 Bad request: No se ha especificado el ataque."
      @url= '/players'+ session[:id]+'/games'+ params[:id_game]
      @msj_url= "Volver"
      erb :error, :layout => :layout
    end
    ship= game.enemy_ship(session[:id],params[:attack].to_s)
    if ship.empty?
      game.create_attack(session[:id], params[:attack].to_s, "miss")
    else
      game.create_attack(session[:id], params[:attack].to_s, "throw")
      ship.last.is_attacked
    end  
    status 201
    if game.enemy_ships_saved?(session[:id])     
      idPlayer= session[:id].to_s
      game.update_turn(session[:id])
      redirect '/players/'+ idPlayer +'/games/' + params[:id_game]
    else
      game.update_turn(0)
      @message= "Has ganado!"
      erb :"/game/game_over", :layout => :layout
    end
  end
  
  get '/esperar/:id/games/:id_game' do
    game= Game.find_by id:(params[:id_game])
    if game.wait_enemy?(session[:id])
      sleep 1
    end
    idPlayer= session[:id].to_s
    redirect '/players/' + idPlayer + '/games/' + params[:id_game]
  end

end