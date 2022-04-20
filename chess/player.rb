require_relative "board"
require_relative "display"
require_relative "game"
require 'byebug'
class Player
  attr_reader :display, :color, :select
  attr_writer :select
  
  def initialize(display, color)
    @display = display
    @color = color 
    @select = nil
  end

  def make_move(board)
    # debugger
    display.render
    input = display.cursor.get_input
    if !input.nil? 
      p input
      p select
      if select.nil?
        raise "This is the wrong color" if board[input].color != color
        @select = input
        return nil
      else
        move = [select.dup, input.dup]
        @select = nil  
        return move
      end
    end 
  end


end