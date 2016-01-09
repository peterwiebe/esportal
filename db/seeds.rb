class Abios
  def initialize
    @api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"
    @games_root       = "https://api.abiosgaming.com/v1/games"
    @matches_root     = "https://api.abiosgaming.com/v1/matches"
    @competitors_root = "https://api.abiosgaming.com/v1/competitors"
    @tournaments_root = "https://api.abiosgaming.com/v1/tournaments"
  end

  def get_games
    puts "getting all games"
    HTTParty.get(@games_root + @api_key)
  end

  def get_tournaments
    puts "getting all tournaments"
    HTTParty.get(@tournaments_root + @api_key)
  end

  def get_matches_by_tournament
  end

  def get_competitors
    # TODO
  end

  def get_competitors_by_tournament(tournament_id)
    puts "tournament_id: #{tournament_id}"
    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@competitors_root + @api_key + filter)
  end

  def get_stream_by_tournament(tournament_id)
    puts "tournament_id: #{tournament_id}"
    HTTParty.get(@tournaments_root + "/" + tournament_id.to_s + @api_key).fetch("url")
  end

  def get_tournaments_by_game(game_id)
    puts "game_id: #{game_id}"
    filter = "&games[]=" + game_id.to_s
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  private

  def get_matches
    "getting matches"
    HTTParty.get(@matches + @api_key)
  end

  def get_matches_by_tournament(tournament_id)
    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@matches_root + @api_key + filter)
  end
end

a = Abios.new

GAMES       = a.get_games
TOURNAMENTS = GAMES.map       {|game| a.get_tournaments_by_game(game["id"])}.flatten
COMPETITORS = TOURNAMENTS.map {|tournament| a.get_competitors_by_tournament(tournament["id"])}
STREAMS     = TOURNAMENTS.map {|tournament| a.get_stream_by_tournament(tournament["id"])}

GAMES.each do |game|

  Game.create(
    id:   game["id"],
    name: game["title"]
    )
end

binding-pry

# TOURNAMENTS.each do |tournament|
#   Tournament.create(
#     id:         tournament["id"],
#     name:       tournament["title"],
#     start_date: tournament["start"],
#     end_date:   tournament["end"],
#     game_id:    tournament["game"]["id"]
#     )
# end

# COMPETITORS.each do |competitor|
#   Competitor.create(
#     id:            competitor["id"],
#     name:
#     tournament_id:
#     )
# end

# STREAMS.each do |stream|

# end