require_relative 'int_code.rb'

class Day11
  class Hull

    OUTPUT_TYPE_COLOR = 0
    OUTPUT_TYPE_DIR = 1
    OUTPUT_COLOR_BLACK = 0
    OUTPUT_COLOR_WHITE = 1
    OUTPUT_VAL_LEFT = 0
    OUTPUT_VAL_RIGHT = 1

    DIRECTION_UP = 0
    DIRECTION_DOWN = 1
    DIRECTION_LEFT = 2
    DIRECTION_RIGHT = 3

    def initialize(first_color = OUTPUT_COLOR_BLACK)
      @direction = DIRECTION_UP
      @painted = {}
      @position = [0, 0]
      @painted[@position] = first_color
      @output_type = OUTPUT_TYPE_COLOR
    end

    def painted
      @painted.size
    end

    def ranges
      min_x = 1000
      max_x = -1000
      min_y = 1000
      max_y = -1000
      @painted.each do |position, value|
        if position[0] < min_x
          min_x = position[0]
        end
        if position[0] > max_x
          max_x = position[0]
        end
        if position[1] < min_y
          min_y = position[1]
        end
        if position[1] > max_y
          max_y = position[1]
        end
      end
      puts "x: #{min_x} - #{max_x} y: #{min_y} #{max_y}"
    end

    def dump_painting
      (0..5).each do |y|
        (0..42).each do |x|
          if @painted[[x, y]] == OUTPUT_COLOR_WHITE
            print("W")
          else
            print(" ")
          end
        end
        puts
      end
      nil
    end

    def read
      if @painted[@position] == nil
        return 0
      else
        return @painted[@position]
      end
    end

    def write(value)
      if @output_type == OUTPUT_TYPE_COLOR
        @painted[@position] = value
        @output_type = OUTPUT_TYPE_DIR
      else
        if value == OUTPUT_VAL_LEFT
          case @direction
          when DIRECTION_UP
            @direction = DIRECTION_LEFT
          when DIRECTION_LEFT
            @direction = DIRECTION_DOWN
          when DIRECTION_DOWN
            @direction = DIRECTION_RIGHT
          when DIRECTION_RIGHT
            @direction = DIRECTION_UP
          end
        else
          case @direction
          when DIRECTION_UP
            @direction = DIRECTION_RIGHT
          when DIRECTION_RIGHT
            @direction = DIRECTION_DOWN
          when DIRECTION_DOWN
            @direction = DIRECTION_LEFT
          when DIRECTION_LEFT
            @direction = DIRECTION_UP
          end
        end

        case @direction
        when DIRECTION_LEFT
          @position = [ @position[0] - 1, @position[1] ]
        when DIRECTION_DOWN
          @position = [ @position[0], @position[1] + 1 ]
        when DIRECTION_RIGHT
          @position = [ @position[0] + 1, @position[1] ]
        when DIRECTION_UP
          @position = [ @position[0], @position[1] - 1 ]
        end

        @output_type = OUTPUT_TYPE_COLOR
      end
    end
  end

  def part1(file)
    hull = Hull.new
    engine = IntCode.new(file)
    engine.set_input_reader(hull)
    engine.set_output_writer(hull)
    engine.execute

    hull.painted
  end

  def part2(file)
    hull = Hull.new(Hull::OUTPUT_COLOR_WHITE)
    engine = IntCode.new(file)
    engine.set_input_reader(hull)
    engine.set_output_writer(hull)
    engine.execute

    #hull.ranges
    hull.dump_painting

  end
end
