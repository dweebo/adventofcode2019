require_relative 'int_code'

class Day13

  class Breakout

    VALUE_TYPE_X = 0
    VALUE_TYPE_Y = 1
    VALUE_TYPE_OBJECT = 2

    EMPTY = 0
    WALL = 1
    BLOCK = 2
    PADDLE = 3
    BALL = 4

    JOYSTICK_LEFT = -1
    JOYSTICK_NEUTRAL = 0
    JOYSTICK_RIGHT = 1

    BOARD_WIDTH = 44
    BOARD_HEIGHT = 20

    def initialize
      @value_type = VALUE_TYPE_X
      @blocks = 0
      @last_x = 0
      @last_y = 0
      @score = 0
      @board = Array.new(BOARD_WIDTH * BOARD_HEIGHT, EMPTY)

      @minx = 1000
      @miny = 1000
      @maxx = 0
      @maxy = 0

      @ball_x = 0
      @ball_y = 0
      @paddle_x = 0
      @paddle_y = 0
    end

    def read
      if @paddle_x < @ball_x
        @paddle_x = @paddle_x + 1
        return JOYSTICK_RIGHT
      elsif @paddle_x > @ball_x
        @paddle_x = @paddle_x - 1
        return JOYSTICK_LEFT
      else
        return JOYSTICK_NEUTRAL
      end
    end

    def write(value)
      case @value_type
      when VALUE_TYPE_X
        @last_x = value
        @minx = value if value < @minx
        @maxx = value if value > @maxx
      when VALUE_TYPE_Y
        @last_y = value
        @miny = value if value < @miny
        @maxy = value if value > @maxy
      when VALUE_TYPE_OBJECT
        if @last_x == -1 && @last_y == 0
          @score = value
          print_score
        else
          if value == BALL
            @ball_x = @last_x
            @ball_y = @last_y
          elsif value == PADDLE
            @paddle_x = @last_x
            @paddle_y = @last_y
          end
          @blocks = @blocks + 1
          update_board(value)
          print_board
        end
      end

      @value_type = (@value_type + 1) % 3
    end

    def update_board(value)
      @board[@last_y * BOARD_WIDTH + @last_x] = value
    end

    def to_s
      puts "#{@minx}-#{@maxx} #{@miny}-#{@maxy} #{@blocks} #{@score}"
    end

    def print_score
      puts "score=#{@score}"
    end

    def print_board
      (0...BOARD_HEIGHT).each do |y|
        (0...BOARD_WIDTH).each do |x|
          case @board[y * BOARD_WIDTH + x]
          when WALL
            print "|"
          when BALL
            print "O"
          when PADDLE
            print "_"
          when BLOCK
            print "#"
          when EMPTY
            print " "
          end
        end
        puts
      end
      puts
    end
  end

  def part1()
    breakout = Breakout.new
    engine = IntCode.new('lib/day13.txt')
    engine.set_output_writer(breakout)
    engine.execute

    breakout.to_s
  end

  def part2()
    breakout = Breakout.new
    engine = IntCode.new('lib/day13.txt')
    engine.instructions[0] = 2
    engine.set_input_reader(breakout)
    engine.set_output_writer(breakout)
    engine.execute
  end
end
