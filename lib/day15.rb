require_relative 'int_code'

class Day15

  WALL = 0
  OPEN = 1
  OXYGEN_SYSTEM = 2
  UNEXPLORED = 3
  VISITED = 4

  NORTH = 1
  SOUTH = 2
  WEST = 3
  EAST = 4

  class RepairDroidDFS

    attr_reader :os_x, :os_y

    def initialize(grid, x, y, engine)
      @grid = grid
      @x = x
      @y = y
      @direction = NORTH
      @back_track = false
      @steps = []
      @engine = engine
      #Day15.print_grid(@grid, @x, @y)
    end

    def read
      if @grid[@y-1][@x] == UNEXPLORED
        @direction = NORTH
      elsif @grid[@y][@x-1] == UNEXPLORED
        @direction = WEST
      elsif @grid[@y][@x+1] == UNEXPLORED
        @direction = EAST
      elsif @grid[@y+1][@x] == UNEXPLORED
        @direction = SOUTH
      else
        if @steps.size == 0
          @engine.kill
          NORTH
        end
        last_direction = @steps.last
        @steps = @steps[0, @steps.size - 1]
        @back_track = true
        case last_direction
        when NORTH; @direction = SOUTH
        when SOUTH; @direction = NORTH
        when EAST; @direction = WEST
        when WEST; @direction = EAST
        end
      end

      @direction
    end

    def write(value)
      if value == WALL
        case @direction
        when NORTH; @grid[@y-1][@x] = WALL
        when WEST; @grid[@y][@x-1] = WALL
        when EAST; @grid[@y][@x+1] = WALL
        when SOUTH; @grid[@y+1][@x] = WALL
        end
      elsif value == OPEN || value == OXYGEN_SYSTEM
        case @direction
        when NORTH; @y = @y - 1
        when WEST; @x = @x - 1
        when EAST; @x = @x + 1
        when SOUTH; @y = @y + 1
        end
        @grid[@y][@x] = value
        if @back_track
          @back_track = false
        else
          @steps << @direction
        end
        if value == OXYGEN_SYSTEM
          @os_x = @x
          @os_y = @y
        end
      end
      #Day15.print_grid(@grid, @x, @y)
    end

    def print_grid2
      (0...@grid.length).each do |y|
        (0...@grid[y].length).each do |x|
          if y == @y && x == @x
            print "D"
          else
            case @grid[y][x]
            when WALL; print "W"
            when OPEN; print "."
            when OXYGEN_SYSTEM; print "O"
            when UNEXPLORED; print " "
            end
          end
        end
        puts
      end
      puts
      puts
    end
  end


  def part1
    max_width=45
    max_height=45
    grid = Array.new(max_height)
    (0...max_height).each do |y|
      grid[y] = Array.new(max_width, UNEXPLORED)
    end

    start_x = max_width/2-1
    start_y = max_height/2-1
    grid[start_y][start_x] = OPEN
    engine = IntCode.new('lib/day15.txt')
    droid = RepairDroidDFS.new(grid, start_x, start_y, engine)
    engine.set_input_reader(droid)
    engine.set_output_writer(droid)
    engine.execute

    bfs_grid_part1(grid, start_x, start_y)
  end

  def bfs_grid_part1(grid, start_x, start_y)
    queue = []
    queue << [start_x, start_y, 0]
    while true
      x,y,steps = queue[0]
      queue = queue[1,queue.length]
      #Day15.print_grid(grid, x, y)

      if grid[y][x] == OXYGEN_SYSTEM
        return steps
      else
        grid[y][x] = VISITED
        if grid[y-1][x] != WALL && grid[y-1][x] != VISITED
          queue << [x, y-1, steps+1]
        end
        if grid[y+1][x] != WALL && grid[y+1][x] != VISITED
          queue << [x, y+1, steps+1]
        end
        if grid[y][x-1] != WALL && grid[y][x-1] != VISITED
          queue << [x-1, y, steps+1]
        end
        if grid[y][x+1] != WALL && grid[y][x+1] != VISITED
          queue << [x+1, y, steps+1]
        end
      end
    end
  end

  def part2
    max_width=45
    max_height=45
    grid = Array.new(max_height)
    (0...max_height).each do |y|
      grid[y] = Array.new(max_width, UNEXPLORED)
    end

    start_x = max_width/2-1
    start_y = max_height/2-1
    grid[start_y][start_x] = OPEN
    engine = IntCode.new('lib/day15.txt')
    droid = RepairDroidDFS.new(grid, start_x, start_y, engine)
    engine.set_input_reader(droid)
    engine.set_output_writer(droid)
    engine.execute

    bfs_grid_part2(grid, droid.os_x, droid.os_y)
  end

  def bfs_grid_part2(grid, start_x, start_y)
    queue = []
    queue << [start_x, start_y, 0]
    grid[start_y][start_x] = VISITED
    max_minutes = 0
    while queue.size > 0
      x,y,minutes = queue[0]
      queue = queue[1,queue.length]
      puts "x=#{x},y=#{y}"
      grid[y][x] = VISITED

      if minutes > max_minutes
        max_minutes = minutes
      end
      #Day15.print_grid(grid, x, y)

      if grid[y-1][x] != WALL && grid[y-1][x] != VISITED
        queue << [x, y-1, minutes+1]
      end
      if grid[y+1][x] != WALL && grid[y+1][x] != VISITED
        queue << [x, y+1, minutes+1]
      end
      if grid[y][x-1] != WALL && grid[y][x-1] != VISITED
        queue << [x-1, y, minutes+1]
      end
      if grid[y][x+1] != WALL && grid[y][x+1] != VISITED
        queue << [x+1, y, minutes+1]
      end
    end
    max_minutes
  end

  def self.print_grid(grid, current_x, current_y)
    (0...grid.length).each do |y|
      (0...grid[y].length).each do |x|
        if y == current_y && x == current_x
          print "D"
        else
          case grid[y][x]
          when WALL; print "W"
          when OPEN; print "."
          when OXYGEN_SYSTEM; print "O"
          when VISITED; print "V"
          when UNEXPLORED; print " "
          end
        end
      end
      puts
    end
    puts
    puts
  end

end
