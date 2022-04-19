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

end

class Knight < Piece
  include Steppable 
  POSSIBLE_MOVES = [
    [1, 2], [2, 1], [1, -2], [2, -1], [-1, 2], [-2, 1], [-1, -2], [-2, -1]
  ]
  def initialize(type, color, pos, board)
    super
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
  def move_diff
    return POSSIBLE_MOVES.dup
  end
end


class Queen < Piece
  include Slideable
  def initialize(type, color, pos, board)
    super
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
    new_pos = [x, (y + direction)]
    potential_moves << new_pos if board.valid_pos?(new_pos)
    
    if at_start_row?
      start_new_pos = [x, (y + direction + direction)]
      potential_moves << start_new_pos if board.valid_pos?(start_new_pos)
    end
    potential_moves
  end
  private

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

  
end