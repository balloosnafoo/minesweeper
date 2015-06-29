require_relative "tile"

class Board
  attr_reader :grid

  def initialize
    @grid = new_grid

    # seed_bombs
  end

  def tile_coordinates(tile)
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |other_tile, idx2|
        return [idx1, idx2] if tile == other_tile
      end
    end
  end

  def new_grid
    Array.new(9) do
      Array.new(9) do
        bomb = rand(49) < 1
        Tile.new(bomb, self)
      end
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end

  def flag_pos(pos)
    self[pos].flag
  end

  def bombs_flags_matched?
    grid.each do |row|
      row.each do |tile|
        return false if tile.bombed? && !tile.flagged?
      end
    end
    true
  end

  def safe_spots_revealed?
    grid.flatten.all? do |tile| !tile.bombed? && tile.revealed?
  end

  def all_revealed?
    grid.each do |row|
      row.each { |cell| return false if !cell.revealed }
    end
  end


  def reveal_pos(pos)
    value = self[pos].neighbor_bomb_count
    if self[pos].bombed?
      reveal_bomb
    elsif value > 0
      reveal_number(pos)
    else
      reveal_tiles(pos)
    end
  end

  def reveal_tiles(pos)
    array = [self[pos]]
    until array.empty?
      current_tile = array.shift
      next if current_tile.revealed
      array += current_tile.neighbors if current_tile.neighbor_bomb_count == 0
      current_tile.reveal
    end
  end

  def reveal_bomb
    @grid.each do |row|
      row.each do |cell|
        cell.reveal
      end
    end
  end

  def reveal_number(pos)
    self[pos].reveal
  end

  def render
    system("clear")
    puts "    0  1  2  3  4  5  6  7  8"
    @grid.each_with_index do |row, idx|
      print " #{idx} "
      row.each do |tile|
        print tile.to_s
      end
      puts
    end
  end

end
