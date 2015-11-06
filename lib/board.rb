require './pieces'
require './cursorable'
require 'colorize'

class Board
  attr_reader :grid, :opponent
  attr_accessor :current_player_team

  def checkmate?
    return false
    grid.each do |row|
      row.each do |piece|
        if piece.team== current_player_team
          return false if piece.available_moves.any? do |move|
            !will_be_in_check?((piece.pos), move, current_player_team)
          end
        end
      end
    end
    true
  end

  def currently_in_check?
    king_location = find_king
    grid.each do |row|
      row.each do |piece|
        return true if piece.team == opponent && piece.available_moves.include?(king_location)
      end
    end
    false
  end

  def will_be_in_check?(start_pos, destination)
    dupped_board = dup_board
    dupped_board.make_move(start_pos, destination)
    king_location = find_dupped_king(dupped_board)
    dupped_board.grid.each do |row|
      row.each do |piece|
        return true if piece.team == dupped_board.current_player_team &&
          piece.available_moves.include?(king_location)
      end
    end
    false
  end

  def generate_available_moves_catalog
    grid.each do |row|
      row.each do |piece|
        piece.available_moves
      end
    end
  end

  def make_move(start_position, destination)
    self[destination] = self[start_position]
    self[destination].pos = destination
    self[start_position] = EmptySquare.new(:gray, start_position, self)
    generate_available_moves_catalog
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def rows
    grid
  end

  def occupied?(pos)
    !self[pos].is_a?(EmptySquare)
  end

  def on_board?(pos)
    pos.all? { |pos| pos >= 0 && pos < 8 }
  end

  def swap_players
    if @current_player_team == :white
      @current_player_team = :black
      @opponent = :white
    else
      @current_player_team = :white
      @opponent = :black
    end
  end

  private

  def initialize(generate_new_pieces = false)
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new(:gray, nil, self) } }
    @current_player_team, @opponent = :black, :white
    generate_new_pieces ? setup : dont_setup
  end

  def setup
      populate_board
      generate_available_moves_catalog
  end

  def dont_setup
  end

  def populate_board
    (0...8).each do |cell|
      self[[1, cell]] = Pawn.new(:black, [1, cell], self)
      self[[6, cell]] = Pawn.new(:white, [6, cell], self)
    end
    self[[0, 2]] = Bishop.new(:black, [0, 2], self)
    self[[0, 5]] = Bishop.new(:black, [0, 5], self)
    self[[7, 2]] = Bishop.new(:white, [7, 2], self)
    self[[7, 5]] = Bishop.new(:white, [7, 5], self)
    self[[0, 1]] = Knight.new(:black, [0, 1], self)
    self[[0, 6]] = Knight.new(:black, [0, 6], self)
    self[[7, 1]] = Knight.new(:white, [7, 1], self)
    self[[7, 6]] = Knight.new(:white, [7, 6], self)
    self[[0, 0]] = Rook.new(:black, [0, 0], self)
    self[[0, 7]] = Rook.new(:black, [0, 7], self)
    self[[7, 0]] = Rook.new(:white, [7, 0], self)
    self[[7, 7]] = Rook.new(:white, [7, 7], self)
    self[[0, 4]] = Queen.new(:black, [0, 4], self)
    self[[7, 4]] = Queen.new(:white, [7, 4], self)
    self[[0, 3]] = King.new(:black, [0, 3], self)
    self[[7, 3]] = King.new(:white, [7, 3], self)
  end

  def find_king
    grid.each do |row|
      row.each do |piece|
        return piece.pos if piece.is_a?(King) && piece.team == current_player_team
      end
    end
  end

  def find_dupped_king(dupped_board)
    dupped_board.grid.each do |row|
      row.each do |piece|
        return piece.pos if piece.is_a?(King) && piece.team == opponent
      end
    end
  end

  def dup_board
    dupped_board = Board.new
    dupped_pieces = pieces(dupped_board)
    dupped_pieces.each do |piece|
      dupped_board[piece.pos] = piece
    end
    dupped_board.generate_available_moves_catalog
    dupped_board
  end

  def pieces(board)
    pieces = []

    grid.each do |row|
      row.each do |piece|
        unless piece.is_a?(EmptySquare)
          dup_piece = piece.class.new(piece.team, piece.pos, board)
          pieces << dup_piece
        end
      end
    end

    pieces
  end
end
