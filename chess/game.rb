require_relative "board"
require_relative "display"
require_relative "player"
class Game
  attr_reader :board, :display, :player_one, :player_two, :current_players
  attr_writer :current_players, :player_one, :player_two
  def initialize
    @board = Board.new
    @display = Display.new(board)
    @player_one = Player.new(display, "W")
    @player_two = Player.new(display, "B")
    @current_players = [player_one, player_two]
  end

  def play 
    while !won?
        begin
          p "The current player is #{current_players.first.color}"
          input = nil
          until input.is_a?(Array)
            input = current_players.first.make_move(board)
          end
          start_pos, end_pos = input
          board.move_piece(start_pos, end_pos)
        rescue StandardError => e
          p "There was an error: #{e.message}. Try again!"
          retry
        end
        swap_players
    end
  end

  def won?
    board.checkmate("W") || board.checkmate("B")
  end

  def swap_players
    p "The current player is #{current_players.first.color}"
    current_players.rotate!(1)
    # if current_player == player_one
    #   current_player = player_two
    # else
    #   current_player = player_one
    # end
    #current_player = (current_player.color == "W") ? @player_two : @player_one
    p "The new player is #{current_players.first.color}"
  end
end