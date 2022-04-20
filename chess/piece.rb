require 'singleton'
require_relative 'modules'

class Piece
  attr_accessor :pos, :color, :board, :type
  def initialize(type, color, pos, board)
    @type = type
    @pos = pos
    @color = color
    @board = board
  end

  def moves
  end

  def to_s 
  end

  def test_piece(test_board)
    self.class.new(type, color, pos, test_board)
  end

  def valid_moves
    moves.reject {|move| board.check_move(pos, move, color)}
  end

  def other_color
     return (color == "W") ? "B" : "W"
  end
end

class Knight < Piece
  include Steppable 

  POSSIBLE_MOVES = [
    [1, 2], [2, 1], [1, -2], [2, -1], [-1, 2], [-2, 1], [-1, -2], [-2, -1]
  ]
  def initialize(type, color, pos, board)
    super
  end

  def to_s
    "♞"
  end


  protected
  def move_diff
    return POSSIBLE_MOVES.dup
  end
end

class King < Piece
  include Steppable 

  POSSIBLE_MOVES = [
    [1,0], [1, 1], [-1, 0], [-1, -1], [0, 1], [0,-1], [-1, 1], [1,-1]
  ]
  def initialize(type, color, pos, board)
    super
  end
  
  def to_s
    '♚'
  end

  def move_diff
    return POSSIBLE_MOVES.dup
  end
end


class Queen < Piece
  include Slideable

  def initialize(type, color, pos, board)
    super
  end

  def to_s
    "♛"
  end

  private
  def move_dir
    horizontal_dir + diagonal_dir
  end
end


class Bishop < Piece
  include Slideable
  def initialize(type, color, pos, board)
    super
  end

  def to_s
    "♝"
  end

  private
  def move_dir
    diagonal_dir
  end
end

class Rook < Piece
  include Slideable
  def initialize(type, color, pos, board)
    super
  end

  def to_s
    "♜"
  end

  private
  def move_dir
    horizontal_dir
  end
end

class Pawn < Piece
  def initialize(type, color, pos, board)
    super
  end

  def moves
    dir = forward_dir
    x, y = pos
    potential_moves = []
    new_pos = [x+dir, y]
    potential_moves << new_pos if board.valid_pos?(new_pos, color) && board[new_pos].is_a?(NullPiece)
    
    if at_start_row?
      start_new_pos = [x + dir + dir, y]
      potential_moves << start_new_pos if board.valid_pos?(start_new_pos, color) && board[start_new_pos].is_a?(NullPiece)
    end
    potential_moves += side_attacks(dir)
    potential_moves
  end
  
  def to_s
    "♟"
  end

  def side_attacks(direction)
    x,y = pos
    sides = [ [x + direction, y + 1], [x + direction, y - 1] ]
    sides = sides.select do |move| 
      board.valid_pos?(move, color) && board[move].color == other_color
    end
  end

  def forward_dir
   return -1 if color == "W" 
   return 1
  end

  def at_start_row?
    return true if color == "W" && pos[0] == 6
    return true if color == "B" && pos[0] == 1
    return false
  end
end

class NullPiece < Piece
  include Singleton
  def initialize()
    @type = "_____"
    @color = nil
    @pos = nil
    @board = nil
  end

  def moves
    []
  end

  def to_s
    " "
  end
end