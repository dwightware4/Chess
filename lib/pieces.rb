require './slidable'

class Pieces
  attr_reader :face, :team, :available_moves, :board
  attr_accessor :selected, :pos

  def initialize(team, pos, board)
    @board, @team, @face, @pos = board, team, "", pos
    @selected, @available_moves = false, []
  end
end

class EmptySquare < Pieces

  def available_moves
    available_moves = []
  end

  private

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = "   " : @face = "   "
  end
end

class Pawn < Pieces

  def available_moves
    available_moves = all_pawn_moves
  end

  def all_pawn_moves
    result = []

    if team == :black
      v = pos[0]
      h = pos[1]
      result << [v + 1, h] if board.on_board?([v + 1, h]) && board.occupied?([v + 1, h]) == false
      result << [v + 1, h - 1] if board.on_board?([v + 1, h - 1]) && board[[(v + 1), (h - 1)]].team == opponent_team
      result << [v + 1, h + 1] if board.on_board?([v + 1, h + 1]) && board[[(v + 1), (h + 1)]].team == opponent_team
      result << [v + 2, h] if pos == origin && board[[(v + 2), h]].team != team
    end

    if team == :white
      v = pos[0]
      h = pos[1]
      result << [v - 1, h] if board.on_board?([v - 1, h]) && board.occupied?([v - 1, h]) == false
      result << [v - 1, h - 1] if board.on_board?([v - 1, h - 1]) && board[[(v - 1), (h - 1)]].team == opponent_team
      result << [v - 1, h + 1] if board.on_board?([v - 1, h + 1]) && board[[(v - 1), (h + 1)]].team == opponent_team
      result << [v - 2, h] if pos == origin && board[[(v - 2), h]].team!= team
    end

    result
  end

  private
  attr_reader :origin, :opponent_team

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = " ♟ " : @face = " ♙ "
    @origin = pos.dup
    @opponent_team = team == :black ? :white : :black
  end
end

class Bishop < Pieces
  include Slidable

  def available_moves
    available_moves = all_diagonal_moves
  end

  private

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = " ♝ " : @face = " ♗ "
  end
end

class Knight < Pieces

  def available_moves
    available_moves = all_knight_moves
  end

  def all_knight_moves
    result = []

    [-2, 2, -1, 1].each do |v_offset|
      [-2, 2, -1, 1].each do |h_offset|
        if (v_offset * h_offset).abs == 2
          v = v_offset + pos[0]
          h = h_offset + pos[1]
          next if !board.on_board?([v, h])
          unless board.occupied?([v, h]) && board[[v, h]].team == self.team
            result << [v, h]
          end
        end
      end
    end

    result
  end

  private

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = " ♞ " : @face = " ♘ "
  end
end

class Rook < Pieces
  include Slidable

  def available_moves
    available_moves = all_horizontal_moves
    available_moves += all_vertical_moves
  end

  private

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = " ♜ " : @face = " ♖ "
  end
end

class Queen < Pieces
  include Slidable

  def available_moves
    available_moves = all_horizontal_moves
    available_moves += all_vertical_moves
    available_moves += all_diagonal_moves
  end

  private

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = " ♛ " : @face = " ♕ "
  end
end

class King < Pieces

  def available_moves
    available_moves = all_king_moves
  end

  def all_king_moves
    result = []

    (-1..1).to_a.each do |v_offset|
      (-1..1).to_a.each do |h_offset|
        v = pos[0] + v_offset
        h = pos[1] + h_offset
        next unless board.on_board?([v, h])
        if ((v == pos[0]) && (h == pos[1])) || board[[v, h]].team == team
          next
        else
          result << [v, h]
        end
      end
    end

    result
  end

  private

  def initialize(color, pos, board)
    super(color, pos, board)
    team == :black ? @face = " ♚ " : @face = " ♔ "
  end
end
