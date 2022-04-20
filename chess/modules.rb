 
 # Slideable will be used for Queens, Bishops, Rooks
 module Slideable
  HORIZONTAL_DIRS = [
    [1,0], [0,1], [-1, 0], [0, -1]
  ] 
  DIAGONAL_DIRS = [
    [1,1], [-1,1], [1,-1], [-1,-1]
  ]
  def moves
    potential_directions = move_dir
    potential_moves = []
    potential_directions.each do |direction|
        dx, dy = direction
        x, y = pos
        distance = 1
        collision = false
        until collision == true || !board.valid_pos?([x + (dx * distance), y + (dy * distance)], color)
          end_pos = [x + (dx * distance), y + (dy * distance)]
          potential_moves << end_pos
          collision = true if board.get_color(end_pos) == other_color
          distance += 1
        end
    end
    potential_moves
  end
  
  def horizontal_dir 
    HORIZONTAL_DIRS.dup
  end

  def diagonal_dir 
    DIAGONAL_DIRS.dup
  end

  private
  
  def move_dir
   
  end
 end


 # Steppable will be used for Knights and Kings
 module Steppable
  def moves
    possible_moves = []
    x, y = pos
    
    move_diff.each do |move|
      dx,dy = move
      new_x, new_y = x + dx, y + dy
      new_pos = [new_x, new_y]
      next if !board.valid_pos?(new_pos, color)
      possible_moves << new_pos
    end
    possible_moves
  end

  def move_diff
  
  end

 end
