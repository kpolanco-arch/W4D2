require_relative "cursor"
require 'colorize'
require 'colorized_string'

class Display
  attr_reader :cursor, :board
  def initialize(board)
    @board= board
    @cursor = Cursor.new([0,0],board)
  end

  def render
    rows = @board.rows
    rows.each_with_index do |row, i| 
      output = ""
      row.each_with_index do |col, j|
        piece = @board[[i,j]]
        piece_type = piece.to_s
        string_color = nil
        background_color = nil

        if piece.color == "W"
          string_color = :yellow
        elsif piece.color == "B"
          string_color = :blue
        else
          string_color = :white
        end

        if [i,j] == @cursor.cursor_pos
          if @cursor.selected 
            background_color = :red
          else
            background_color = :pink
          end
        else
          background_color = :white
          if (i.even? && j.even?) || (i.odd? && j.odd?)
            background_color = :green
          end
        end
        output += piece_type.colorize(string_color).colorize(:background => background_color)
      end
      puts output
    end
  end 

end



