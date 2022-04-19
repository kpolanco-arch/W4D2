require_relative "piece"

class Board
  attr_accessor :GRID, :rows
  GRID = [
    ["B_ROK", "B_KNI", "B_BIS", "B_QUE", "B_KIN", "B_BIS", "B_KNI", "B_ROK"],
    ["B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW", "B_PAW"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["NIL", "NIL", "NIL", "W_QUE", "W_KNI", "NIL", "NIL", "NIL"],
    ["NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL", "NIL"],
    ["W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW", "W_PAW"],
    ["W_ROK", "W_KNI", "W_BIS", "W_KIN", "W_QUE", "W_BIS", "W_KNI", "W_ROK"],
  ]
  
  def initialize
    
    @rows = Array.new(8) { Array.new(8, nil)}
    @NillPiece = NullPiece.instance
    populate_board
 
  end

  def [](pos)
    x, y = pos
    @rows[x][y]
  end

  def []=(pos,value)
      x, y = pos
     @rows[x][y] = value
  end

  def move_piece(start_pos, end_pos)
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
  
  def render
    @rows.each { 
      |row|
      row_cont = ""
      row.each { |ele| row_cont += ele.type + " "}
      p row_cont
    }
  end

  def valid_pos?(position)
    x,y = position
    return false if !self[position].is_a?(NullPiece)
    return false if !(0..7).include?(x) || !(0..7).include?(y)
    return true
  end
end

b = Board.new
b.render
p b[[0,1]].type