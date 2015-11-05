require './cursorable'
require 'colorize'

class Display
  include Cursorable

  def initialize(board)
    @board, @cursor_pos = board, [0, 0]
  end

  def render
    system("clear")
    puts "Arrow keys to move, Space to select"
    puts "#{board.current_player.capitalize} Team's Turn!"
    puts "#{board.current_player.capitalize} is in check" if board.currently_in_check?(@board.current_player)
    build_grid.each do |row|
      puts row.join
    end
  end

  private
  attr_reader :cursor_pos, :board

  def build_grid
    board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.face.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == cursor_pos
      bg = :green
    elsif board[[i, j]].selected
      bg = :cyan
    elsif board[cursor_pos].available_moves.include?([i, j])
      bg = :light_blue
    elsif (i + j).odd?
      bg = :light_black
    else
      bg = :light_white
    end
    { background: bg, color: :black }
  end
end
