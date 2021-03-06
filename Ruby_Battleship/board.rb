require_relative 'requirement'

class Board
  DEFAULT_SETUP = [[[Carrier], ['A4', 'B4', 'C4', 'D4', 'E4']], [[Battleship], ['A7', 'B7', 'C7', 'D7']], [[Cruiser], ['A9', 'B9', 'C9']], [[Submarine], ['A10', 'B10', 'C10']], [[Destroyer], ['A1', 'B1']]]

  def initialize(opts)
    @grid =[[0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0]]
    if opts[:manual_setup]
      player_setup
    else
      auto_set_up
    end
  end

  def auto_set_up
    DEFAULT_SETUP.each do |ship, coordinates|
      ship_place(ship, coordinates)
    end
  end

  def player_set_up
    Ship::SHIP_CLASSES.each do |ship|
      puts 
    end
  end
end