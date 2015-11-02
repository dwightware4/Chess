require_relative 'board.rb'
require_relative 'display.rb'
require_relative 'cursorable.rb'
require_relative 'pieces.rb'
require 'byebug'

class Game

  def initialize
    @board = Board.new(true)
    @display = Display.new(board)
  end

  def play
    play_turn while true
  end

  private
  attr_reader :display, :board

    def play_turn
      display.render

      opponent = board.current_player == :black ? :white : :black
      if board.checkmate?(board.current_player)
        Kernel.abort("#{board.current_player} Wins!")
      end
      # gets and validates starting position
      start_position = nil
      until start_position && board.occupied?(start_position) && !board[start_position].available_moves.empty?
        start_position = get_move
      end

      board[start_position].selected = true

      # bug exists due to inability to deselect pieces or retry when move fails
      # gets and validates destination position
      destination = nil
      until destination && board[start_position].available_moves.include?(destination) && !@board.will_be_in_check?(start_position, destination, @board.current_player)
        destination = get_move
      end

      board[start_position].selected = false
      board.make_move(start_position, destination)
      board.swap_players
    end

    def get_move
      result = nil
      until result
        display.render
        result = display.get_input
      end
      result
    end
end

class UnoccupiedError < StandardError
end

class InvalidMoveError < StandardError
end

class InCheckError < StandardError
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
