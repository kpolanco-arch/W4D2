require_relative "piece"

class Board
  attr_accessor :GRID, :rows, :NillPiece
  GRID = [
    ["B_ROK", "B_KNI", "B_BIS", "B_QUE", "B_KIN", "B_BIS", "B_KNI", "B_ROK"],
    ["B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW"],
    ["W_ROK", "W_KNI", "W_BIS", "W_QUE", "W_KIN", "W_BIS", "W_KNI", "W_ROK"],
  ]
  
  def initialize(test = false)
    @rows = Array.new(8) { Array.new(8, "_")}
    @NillPiece = NullPiece.instance
    populate_board 
  end

  def [](pos)
    x, y = pos
    return @rows[x][y]
  end

  def []=(pos,value)
    x, y = pos
    @rows[x][y] = value
  end

  def get_color(position)
    return self[position].color
  end

  def move_piece(start_pos, end_pos)
    raise "There is no piece at the start position" if self[start_pos].is_a?(NullPiece)
    raise "This movement is out of bounds" if end_pos.any? { |index| !(0..7).include?(index)}
    raise "This movement is not valid for this piece" if !self[start_pos].valid_moves.include?(end_pos)
    raise "This move would put you into check" if check_move(start_pos, end_pos, self[start_pos].color)
    self[end_pos] = self[start_pos]
    self[start_pos] = @NillPiece # NullPiece.new("_____", nil, start_pos, self)
    self[end_pos].pos = end_pos
  end
  
  def move_piece!(start_pos, end_pos)
    raise "There is no piece at the start position" if self[start_pos].is_a?(NullPiece)
    raise "The end position is not valid" if end_pos.any? { |index| !(0..7).include?(index)}
    self[end_pos] = self[start_pos]
    self[start_pos] = @NillPiece # NullPiece.new("_____", nil, start_pos, self)
    self[end_pos].pos = end_pos
  end
  
  def populate_board
    GRID.each_with_index do |row, x|
      row.each_with_index do |col, y|
        piece_info = GRID[x][y]
        pos = [x,y]
        if piece_info == "NIL"
          self[pos] =  @NillPiece # NullPiece.new("_____", nil, pos, self)
        else
          piece_info2 = piece_info.split("_")
          piece_color = piece_info2[0]
          piece_type = piece_info2[1]
          if piece_type == "KNI"
              self[pos] = Knight.new(piece_info, piece_color, pos, self)
          elsif piece_type == "BIS"
              self[pos] = Bishop.new(piece_info, piece_color, pos, self)
          elsif piece_type == "PAW"
              self[pos] = Pawn.new(piece_info, piece_color, pos, self)
          elsif piece_type == "KIN"
              self[pos] = King.new(piece_info, piece_color, pos, self)
          elsif piece_type == "QUE"
              self[pos] = Queen.new(piece_info, piece_color, pos, self)
          elsif piece_type == "ROK"
              self[pos] = Rook.new(piece_info, piece_color, pos, self)
          end
        end
      end 
    end
  end
  
  # def render
  #   @rows.each { 
  #     |row|
  #     row_cont = ""
  #     row.each { |ele| row_cont += ele.type + " "}
  #     p row_cont
  #   }
  # end

  def valid_pos?(position, color)
    x,y = position
    return false if !(0..7).include?(x) || !(0..7).include?(y)
    return false if self[position].color == color
    return true
  end

  def find_pieces_of(color)
    pieces = rows.dup.flatten
    pieces = pieces.select { |piece| piece.color == color }
    return pieces
  end

  def in_check(color)
    king = find_pieces_of(color).select {|piece| piece.is_a?(King) }
    king = king.first
    enemies = find_pieces_of(king.other_color)
    enemies.any? do |piece|
      piece.moves.include?(king.pos)
    end
  end

  def checkmate(color)
    pieces = find_pieces_of(color)
    pieces.all? {|piece| piece.valid_moves.empty? }
  end

  def test_board
    dup_board = Board.new(true) 
    rows.each_with_index do |row, x|
      row.each_with_index do |col, y|
        if self[[x,y]].is_a?(NullPiece)
          dup_board[[x,y]] = @NillPiece 
        else
          dup_board[[x,y]] = self[[x,y]].test_piece(dup_board)
        end
      end
    end
    return dup_board
  end

  def check_move(start_pos, end_pos, color)
    test = test_board 
    test.move_piece!(start_pos, end_pos)
    test.in_check(color)
  end
end

