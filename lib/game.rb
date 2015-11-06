require './board'
require './display'
require './cursorable'
require './pieces'
require 'byebug'

class Game
  
  def play
    until game_over?
      play_turn
    end
  end

  private
  attr_reader :display, :board

  def initialize
    @board = Board.new(true)
    @display = Display.new(board)
  end

  def game_over?
    if board.checkmate?
      Kernel.abort("#{board.current_player.capitalize} Wins!")
    end
    false
  end

  def play_turn
    display.render
    piece = select_piece
    destination = select_destination(piece)
    piece.selected = false
    board.make_move(piece.pos, destination)
    board.swap_players
  end

  def select_piece
    pos = get_pos
    pos = get_pos until board[pos].team == board.current_player
    toggle_selected(pos)
    select_piece unless board[pos].selected
    board[pos]
  end

  def get_pos
    result = nil
    until result
      display.render
      result = display.get_input
    end
    result
  end

  def select_destination(piece)
    pos = get_pos
    pos = get_pos until pos == piece.pos || piece.available_moves.include?(pos)
    if piece.pos == pos
      toggle_selected(pos)
      play_turn
    end
    pos
  end

  def toggle_selected(pos)
    board[pos].selected ? board[pos].selected = false : board[pos].selected = true
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
