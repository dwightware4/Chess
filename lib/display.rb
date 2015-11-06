require './cursorable'
require 'colorize'

class Display
  include Cursorable

  def render
    system("clear")
    build_grid.each do |row|
      puts row.join
    end
    puts "Arrow keys to move, Space to select"
    puts "#{board.current_player_team.capitalize} team's Turn!"
    puts "#{board.current_player_team.capitalize} is in check" if board.currently_in_check?
  end

  private
  attr_reader :cursor_pos, :board

  def initialize(board)
    @board, @cursor_pos = board, [0, 0]
  end

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
    if board[cursor_pos].available_moves.include?([i, j]) && board.current_player_team == board[cursor_pos].team
      bg = :light_blue
    elsif [i, j] == cursor_pos
      bg = :green
    elsif board[[i, j]].selected
      bg = :cyan
    elsif (i + j).odd?
      bg = :light_black
    else
      bg = :light_white
    end
    { background: bg, color: :black }
  end
end
