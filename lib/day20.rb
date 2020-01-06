require 'pry'

class Day20

  attr_reader :jumps, :grid

  # bfs but w/ jumps?
  #   when looking down, if location starts w/ letter then find other end and go there
  #   read into grid arrays
  #   keep track of jumps by label in a map w/ endpoints
  #   in grid store the label at the spot
  #
  #
  # convert to graph and do shortest path alg?
  #   create node AA
  #   find AA, do dfs until find another label, hmm but other labels are in weird places
  #
  class Point
    attr_accessor :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end

    def eql?(other)
      @x == other.x && @y == other.y
    end

    def to_s
      "#{x}, #{y}"
    end
  end

  class Jump
    attr_accessor :point_1, :point_2, :point_1_next, :point_2_next

    def initialize(point_1, point_1_next)
      @point_1 = point_1
      @point_1_next = point_1_next
    end
  end

  def initialize
    @jumps = {}
  end

  def part1(file)
    parse_maze(file)

    bfs(@grid)
  end

  def parse_maze(file)
    grid = File.read(file).split("\n").map do |line|
      line.split("")
    end
    @grid = grid

    (0...grid.size).each do |y|
      (0...grid[y].size).each do |x|
        if letter(grid[y][x])
          if letter(grid[y + 1][x])
            if grid.size > y + 2 && grid[y + 2][x] == "."
              grid[y + 1][x] = grid[y][x] + grid[y + 1][x]
              grid[y][x] = " "
              add_jump(x, y + 1, x, y + 2, grid[y + 1][x])
            elsif grid[y-1][x] == "."
              grid[y][x] = grid[y][x] + grid[y + 1][x]
              grid[y + 1][x] = " "
              add_jump(x, y, x, y - 1, grid[y][x])
            end
          elsif letter(grid[y][x + 1])
            if grid[y][x + 2] == "."
              grid[y][x + 1] = grid[y][x] + grid[y][x + 1]
              grid[y][x] = " "
              add_jump(x + 1, y, x + 2, y, grid[y][x + 1])
            elsif grid[y][x - 1] == "."
              grid[y][x] = grid[y][x] + grid[y][x + 1]
              grid[y][x + 1] = " "
              add_jump(x, y, x - 1, y, grid[y][x])
            end
          end
        end
      end
    end
  end

  def add_jump(x, y, x_next, y_next, label)
    if @jumps[label].nil?
      puts "add jump #{x},#{y},#{x_next},#{y_next},#{label}."
      @jumps[label] = Jump.new(Point.new(x, y), Point.new(x_next, y_next))
    else
      puts "add to jump #{x},#{y},#{x_next},#{y_next},#{label}."
      @jumps[label].point_2 = Point.new(x, y)
      @jumps[label].point_2_next = Point.new(x_next, y_next)
    end
  end

  def letter(x)
    x >= "A" && x <= "Z"
  end

  def print_grid(grid)
    (0...grid.length).each do |y|
      (0...grid[y].length).each do |x|
        print grid[y][x]
      end
      puts
    end
    puts
  end

  def bfs(grid)
    aa = @jumps["AA"]
    start = aa.point_1_next
    grid[aa.point_1.y][aa.point_1.x] = " "
    queue = [[start, 0]]
    while queue.size > 0
      pt, steps = queue[0]
      queue = queue[1,queue.length]

      print_grid(grid)

      puts "check #{pt} #{grid[pt.y][pt.x]}"
      case grid[pt.y][pt.x]
      when "ZZ"
        puts "found in #{steps - 1} steps"
        return steps - 1
      when "#"
        next
      when "v"
        next
      when " "
        next
      when "."
        grid[pt.y][pt.x] = "v"
        queue += surrounding_pts(grid, pt).map { |pt| [ pt, steps + 1] }
      end
    end
  end

  def surrounding_pts(grid, pt)
    pts = []
    add_surrounding_pt(grid, pts, Point.new(pt.x, pt.y + 1))
    add_surrounding_pt(grid, pts, Point.new(pt.x, pt.y - 1))
    add_surrounding_pt(grid, pts, Point.new(pt.x + 1, pt.y))
    add_surrounding_pt(grid, pts, Point.new(pt.x - 1, pt.y))
    pts
  end

  def add_surrounding_pt(grid, pts, pt)
    if grid[pt.y][pt.x] == "." || grid[pt.y][pt.x] == "ZZ"
      pts << Point.new(pt.x, pt.y)
    elsif grid[pt.y][pt.x].size == 2
      j = @jumps[grid[pt.y][pt.x]]
      if j.point_1.eql?(pt)
        pts << j.point_2_next
      else
        pts << j.point_1_next
      end
    end
  end

  def part2(file)
    # identify jumps as inner/outer
    #   basically can just check x/y coords
    # track what level in addition to steps in queue
    # when level=0 outer jumps don't work
    # when level>0 ZZ is a wall
    # otherwise inner jumps increase level, outer jumps decrease level
    # need to track visited per level
    #
    # but bfs still should work
    #
    parse_maze(file)

    bfs_part2(@grid)
  end

  def bfs_part2(grid)
    aa = @jumps["AA"]
    start = aa.point_1_next
    grid[aa.point_1.y][aa.point_1.x] = " "
    queue = [[start, 0, 0]]
    visited = {}

    while queue.size > 0
      pt, steps, level = queue[0]
      queue = queue[1,queue.length]

      #print_grid(grid)
      visited_key="#{level},#{pt.x},#{pt.y}"
      if visited[visited_key]
        next
      else
        visited[visited_key] = true
      end

      puts "#{level}:#{steps} check #{pt} #{grid[pt.y][pt.x]}"
      case grid[pt.y][pt.x]
      when "ZZ"
        if level == 0
          puts "found in #{steps - 1} steps"
          return steps - 1
        else
          next
        end
      when "#"
        next
      when "v"
        next
      when " "
        next
      when "."
        add_surrounding_pt_part2(grid, queue, level, steps, Point.new(pt.x, pt.y + 1))
        add_surrounding_pt_part2(grid, queue, level, steps, Point.new(pt.x, pt.y - 1))
        add_surrounding_pt_part2(grid, queue, level, steps, Point.new(pt.x + 1, pt.y))
        add_surrounding_pt_part2(grid, queue, level, steps, Point.new(pt.x - 1, pt.y))
      end
    end
  end

  def outer_jump?(pt)
     pt.y < 2 ||
     pt.y > (@grid.size - 3) ||
     pt.x < 2 ||
     pt.x > (@grid[0].size - 3)
  end

  def add_surrounding_pt_part2(grid, queue, level, steps, pt)
    if grid[pt.y][pt.x] == "." || (level == 0 && grid[pt.y][pt.x] == "ZZ")
      queue << [ Point.new(pt.x, pt.y), steps + 1, level ]
    elsif grid[pt.y][pt.x].size == 2 && grid[pt.y][pt.x] != "ZZ"
      label = grid[pt.y][pt.x]
      j = @jumps[label]

      if outer_jump?(pt)
        if level == 0
          puts "don't jump to outer jump #{label} on first level"
          return
        end
        level -= 1
        puts "jump up #{label} #{level}"
      else
        level += 1
        puts "jump down #{label} #{level}"
      end

      if j.point_1.eql?(pt)
        queue << [ j.point_2_next, steps + 1, level ]
      else
        queue << [ j.point_1_next, steps + 1, level ]
      end
    end
  end

end
