class Server < Sinatra::Base
  
  def game_exist
    game= Game.where("games.id == #{params[:id_game]} AND (games.creator_id == #{session[:id]} OR games.opponent_id == #{session[:id]})")
    if game.length == 0
      halt 400, "400 Bad request" + " <a href='/players/#{session[:id]}/games'> Volver al listado de las partidas </a>"
    end
  end
  
  def game_turn_player
    game= Game.where("games.id == #{params[:id_game]} AND (games.creator_id == #{session[:id]} OR games.opponent_id == #{session[:id]})")
    if game.length <= 0
      halt 400, "400 Bad request" + " <a href='/players/#{session[:id]}/games'> Volver al listado de las partidas </a>"
    end
    if game.last.turn == session[:id]
      halt 403, "403 Forbidden: Turno del rival." + " <a href='/players/#{session[:id]}/games/#{params[:id_game]}'> Volver </a>"
    end
    if params[:attack] == nil
      halt 400, "400 Bad request: No se ha especificado el ataque" + " <a href='/players/#{session[:id]}/games/#{params[:id_game]}'> Volver </a>"
    end
  end
 
  
  def ships_remaining
    case @game.table
    when 5
      @ships_remaining= 7
    when 10
      @ships_remaining= 15
    else
      @ships_remaining= 20
    end
  end
  
  def destroy_game_complete
    game_ships= Ship.where(id_game:params[:id_game])
    for ship in game_ships
      ship.destroy
    end
    game_attacks= Attack.where(id_game:params[:id_game])
    for attack in game_attacks
      attack.destroy
    end
    Game.delete(params[:id_game])
  end
  
end