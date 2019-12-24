require_relative 'int_code'

class Day17

  OPEN = "."
  STRUT = "#"
  COMMA = ','
  NEW_LINE = "\n"

  class AsciiPart1
    attr_reader :grid

    def initialize(width, height)
      @grid = Array.new(height)
      (0...height).each do |y|
        grid[y] = Array.new(width, OPEN)
      end
      @x = 0
      @y = 0
    end

    def write(value)
      if value == 10
        @y += 1
        @x = 0
      else
        @grid[@y][@x] = value.chr
        @x = @x + 1
      end
    end

    def debug_grid()
      @grid.each do |row|
        puts row.join('')
      end
    end

  end

  def part1

    ascii = AsciiPart1.new(60, 40)
    engine = IntCode.new('lib/day17.txt')
    engine.set_output_writer(ascii)
    engine.execute
    ascii.debug_grid

    intersections(ascii.grid).each do |intersection|
      puts "int = #{intersection}"
    end

    intersections(ascii.grid).map {|intersection| intersection[0] * intersection[1] }.sum
  end

  def intersections(grid)
    intersections = []
    (0...grid.size).each do |y|
      (0...grid[y].size).each do |x|
        if grid[y][x] == STRUT &&
           grid[y-1][x] == STRUT &&
           grid[y+1][x] == STRUT &&
           grid[y][x-1] == STRUT &&
           grid[y][x+1] == STRUT
          intersections << [ x, y ]
        end
      end
    end
    intersections
  end

  def part2()
    ascii = AsciiPart2.new(60, 40)
    engine = IntCode.new('lib/day17.txt')
    engine.instructions[0] = 2
    engine.set_output_writer(ascii)
    engine.set_input_reader(ascii)
    engine.execute
  end

  class AsciiPart2

    def initialize(width, height)
      @receiving_board = true
      @grid = Array.new(height)
      (0...height).each do |y|
        @grid[y] = Array.new(width, OPEN)
      end
      @x = 0
      @y = 0

      @program = [
        'A',COMMA,'B',COMMA,'B',COMMA,'C',COMMA,'C',COMMA,'A',COMMA,'A',COMMA,'B',COMMA,'B',COMMA,'C',NEW_LINE,
        'L',COMMA,49,50,COMMA,'R',COMMA,52,COMMA,'R',COMMA,52,NEW_LINE,
        'R',COMMA,49,50,COMMA,'R',COMMA,52,COMMA,'L',COMMA,49,50,NEW_LINE,
        'R',COMMA,49,50,COMMA,'R',COMMA,52,COMMA,'L',COMMA,54,COMMA,'L',COMMA,56,COMMA,'L',COMMA,56,NEW_LINE,
        'y',NEW_LINE
      ]
    end

    def read
      command = @program[0]
      @program = @program[1, @program.size - 1]
      if command.is_a?(Integer)
        code = command
      else
        code = command.ord
      end
      puts "read #{code}"
      code
    end

    def write(value)
      puts "value=#{value}"
    end

    def write(value)
      if @receiving_board
        if value == 10
          @y += 1
          @x = 0
          if @y == 40
            debug_grid
            @receiving_board = false
            @x = 0
            @y = 0
          end
        else
          @grid[@y][@x] = value.chr
          @x = @x + 1
        end
      else
        print value.chr
      end
    end

    def debug_grid()
      @grid.each do |row|
        puts row.join('')
      end
    end
  end
end
