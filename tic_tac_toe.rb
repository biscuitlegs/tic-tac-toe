class Board
    attr_accessor :squares

    def initialize
        @squares = {
            A3: Square.new,
            B3: Square.new,
            C3: Square.new,
            A2: Square.new,
            B2: Square.new,
            C2: Square.new,
            A1: Square.new,
            B1: Square.new,
            C1: Square.new,
        }
    end

    def show
        puts "\n" + "Okay, here's how the board looks now:"

        last_position = "C3"

        self.squares.each do |position, piece|
            puts "\n" + "\s"*3 + "-"*17 if position.to_s[0] < last_position[0]
           
            if position.to_s.match(/(A1|A2|A3)/)
                print "#{position.to_s[1]}    #{piece}  "
            elsif position.to_s[0] == "B"
                print "|  #{piece}  |"
            else
                print "  #{piece}"
            end

            last_position = position.to_s
        end

        puts "\n" + "\s"*3 + "-"*17
        puts "\s"*5 + "A" + "\s"*5 + "B" + "\s"*5 + "C" + "\n"*2
    end

    def place_piece(piece, position)
        self.squares[position].piece = piece
    end

    def victory?
        def direction_match?(lines)
            lines.each_slice(3) do |slice|
                return true if slice.all? {|square| square.piece == "cross"}
                return true if slice.all? {|square| square.piece == "nought"}
            end
        end

        rows = self.squares.sort {|a, b| a[0][1] <=> b[0][1]}.to_h.values
        columns = self.squares.sort {|a, b| a[0][0] <=> b[0][0]}.to_h.values
        diagonals = [
            self.squares[:A1], self.squares[:B2], self.squares[:C3],
            self.squares[:C1], self.squares[:B2], self.squares[:A3]
        ]

        return true if direction_match?(rows) || direction_match?(columns) || direction_match?(diagonals)
       

        false
    end

    def stalemate?
        self.squares.all? {|position, square| square.piece} ? true : false
    end
end

class Square
    attr_accessor :piece
    
    def initialize(piece=nil)
        @piece = piece
    end

    def to_s
        if self.piece == "nought"
            "O"
        elsif self.piece == "cross"
            "X"
        else
            " "
        end
    end
end

class Player
    attr_reader :name, :pieces
    
    def initialize(name, pieces=nil)
        @name = name
        @pieces = pieces
    end

    def to_s
        self.name
    end
end

def play_turn(player, board)
    puts "-"*12
    puts "#{player.name.upcase}'s TURN:"
    puts "-"*12
    puts "#{player.name}, please enter a position to put a #{player.pieces.to_s}:"
    puts "\n"
    board.place_piece(player.pieces, get_choice(board))
    board.show
end

def get_choice(board)
    choice = gets.chomp.upcase.to_sym

    while !choice.to_s.match(/[ABC][123]/) || board.squares[choice].piece
        puts "\n"
        puts "That position doesn't exist or there's already another piece there."
        puts "Please choose another position:" + "\n"*2
        choice = gets.chomp.upcase.to_sym
    end

    choice
end


my_board = Board.new

puts "Player 1, please enter your name:"
player_one = Player.new(gets.chomp, "nought")
puts "\n"
puts "Player 2, please enter your name:"
player_two = Player.new(gets.chomp, "cross")
puts "\n"

puts "#{player_one} will be noughts(O) and #{player_two} will be crosses(X)."
my_board.show


players = [player_one, player_two]

until my_board.victory? || my_board.stalemate?
    play_turn(players.first, my_board)
    players.rotate!
end

if my_board.victory?
    puts "Congrats #{players.last}, you won!"
else
    puts "Looks like there's no spaces left! I guess there's no winner this time, then."
end

puts "Game Over. Thanks for playing!"