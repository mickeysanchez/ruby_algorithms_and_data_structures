class Board
  attr_reader :rows

  def self.blank_grid
    Array.new(3) { Array.new(3) }
  end

  def initialize(rows = self.class.blank_grid)
    @rows = rows
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, mark)
    raise "mark already placed there!" unless empty?(pos)

    x, y = pos[0], pos[1]
    @rows[x][y] = mark
  end

  def cols
    cols = [[], [], []]
    @rows.each do |row|
      row.each_with_index do |mark, col_idx|
        cols[col_idx] << mark
      end
    end

    cols
  end

  def diagonals
    down_diag = [[0, 0], [1, 1], [2, 2]]
    up_diag = [[0, 2], [1, 1], [2, 0]]

    [down_diag, up_diag].map do |diag|
      # Note the `x, y` inside the block; this unpacks, or
      # "destructures" the argument. Read more here:
      # http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
      diag.map { |x, y| @rows[x][y] }
    end
  end

  def dup
    duped_rows = rows.map(&:dup)
    self.class.new(duped_rows)
  end

  def empty?(pos)
    self[pos].nil?
  end

  def tied?
    return false if won?

    # no empty space?
    @rows.all? { |row| row.none? { |el| el.nil? }}
  end

  def over?
    # style guide says to use `or`, but I (and most others) prefer to
    # use `||` all the time. We don't like two ways to do something
    # this simple.
    won? || tied?
  end

  def winner
    (rows + cols + diagonals).each do |triple|
      return :x if triple == [:x, :x, :x]
      return :o if triple == [:o, :o, :o]
    end

    nil
  end

  def won?
    !winner.nil?
  end
end

# Notice how the Board has the basic rules of the game, but no logic
# for actually prompting the user for moves. This is a rigorous
# decomposition of the "game state" into its own pure object
# unconcerned with how moves are processed.

class TicTacToe
  class IllegalMoveError < RuntimeError
  end

  attr_reader :board, :players, :turn

  def initialize(player1, player2)
    @board = Board.new
    @players = { :x => player1, :o => player2 }
    @turn = :x
  end

  def run
    until self.board.over?
      play_turn
    end

    if self.board.won?
      winning_player = self.players[self.board.winner]
      puts "#{winning_player.name} won the game!"
    else
      puts "No one wins!"
    end
    self.show
  end

  def show
    # not very pretty printing!
    self.board.rows.each { |row| p row }
  end

  private
  def place_mark(pos, mark)
    if self.board.empty?(pos)
      self.board[pos] = mark
      true
    else
      false
    end
  end

  def play_turn
    while true
      current_player = self.players[self.turn]
      pos = current_player.move(self, self.turn)

      break if place_mark(pos, self.turn)
    end

    # swap next whose turn it will be next
    @turn = ((self.turn == :x) ? :o : :x)
  end
end

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def move(game, mark)
    game.show
    while true
      puts "#{@name}: please select your space"
      x, y = gets.chomp.split(",").map(&:to_i)
      if HumanPlayer.valid_coord?(x, y)
        return [x, y]
      else
        puts "Invalid coordinate!"
      end
    end
  end

  private
  def self.valid_coord?(x, y)
    [x, y].all? { |coord| (0..2).include?(coord) }
  end
end

class ComputerPlayer
  attr_reader :name

  def initialize
    @name = "Tandy 400"
  end

  def move(game, mark)
    winner_move(game, mark) || random_move(game)
  end

  private
  def winner_move(game, mark)
    (0..2).each do |x|
      (0..2).each do |y|
        board = game.board.dup
        pos = [x, y]

        next unless board.empty?(pos)
        board[pos] = mark

        return pos if board.winner == mark
      end
    end

    # no winning move
    nil
  end

  def random_move(game)
    puts "I'm doing a random move"
    board = game.board
    while true
      range = (0..2).to_a
      pos = [range.sample, range.sample]

      return pos if board.empty?(pos)
    end
  end
end

class SuperComputerPlayer < ComputerPlayer
  def winner_move(game, mark)
    puts "doing a winner move"
    
    # game.board.rows returns a board array
    # game.turn returns the next symbol to move 
    node = TicTacToeNode.new(game.board.rows, game.turn)

    node.children.each do |child|
      return child.prev_move_pos if child.winning_node?
    end
    
    # if we don't return from those children, then we should "avoid a losing node"
    
    puts "doing a random move"
    nil # if this is nil, then we'll do a random move
  end
end


class TicTacToeNode
  attr_reader :board, :prev_move_pos

  def initialize(board, next_symbol_to_move, prev_move_pos = nil)
    @board = board # a 3X3 array
    @b = Board.new(board)
    @next_symbol_to_move = next_symbol_to_move
    @children = []
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(player = @next_symbol_to_move)
    b = Board.new(@board)
    b.winner != player
  end

  def winning_node?(player = @next_symbol_to_move)
    puts "1"
    return true if @b.winner == player
    
    puts "2"
    self.children.each do |child|
      return true if child.winning_node?(player)
    end
    
    puts "3"
    self.children.all? do |child|
      child.winning_node?(player)
    end
    
    puts "4"
    false
  end

  def children
    possible_board_nodes = []
    
    nil_coordinates = []
    @board.each_with_index do |row, y|
      row.each_with_index do |spot, x|
        nil_coordinates << [y,x] if spot == nil
      end
    end
    
    nil_coordinates.each do |pair|
      possible_board = deep_dup(@board)
      y = pair[0]
      x = pair[1]
      possible_board[y][x] = @next_symbol_to_move
      @next_symbol_to_move == :x ? next_next = :y : next_next = :x
      possible_board_nodes << TicTacToeNode.new(possible_board, next_next, [y,x])
    end
  
    @children = possible_board_nodes
  end

  def deep_dup(arr)
    duped_array = []
    arr.each do |el|
      if el.is_a? Array
        duped_array << deep_dup(el)
      else
        temp_array = []
        if el.is_a?(Symbol) || el.nil?
          temp_array << el
        else
          temp_array << el.dup
        end
        duped_array += temp_array
      end
    end
    duped_array
  end
end

# board = [[:x,  :o,  :o], 
#          [:x,  :o,  :x],
#          [nil, :x,  :o]]
# 
# t = TicTacToeNode.new(board, :x)
# # t.children.each {|child| child.board.each do |row| 
# #   p row
# # end }
# # p t.children
# p t.children

if __FILE__ == $PROGRAM_NAME
  hp = HumanPlayer.new("Ned")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end

