require_relative "board"

class Minesweeper
  attr_reader :board

  def initialize
    @board = Board.new
    run
  end

  def run
    until game_won? || game_lost?
      board.render
      position, action = get_input
      if action == "f"
        board.flag_pos(position)
      else
        board.reveal_pos(position)
      end
    end
    board.render
    if game_won?
      puts "Congratulations you won"
    else
      puts "You died"
    end
  end

  def game_won?
    board.bombs_flags_matched? && board.safe_spots_revealed?
  end

  def game_lost?
    board.all_revealed?
  end

  def get_input
    puts "What position would you like to inspect? "
    position = gets.chomp.split(",").map(&:to_i)
    puts "(I)nspect or (F)lag? "
    action = gets.chomp.downcase
    [position, action]
  end

end
