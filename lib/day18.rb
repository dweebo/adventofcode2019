require 'pry'

class Day18

  # find all keys manually a-z
  # from starting point, do dfs for each key
  # if can't get to it (blocked by door) throw that attempt away
  # if can get to the key, record how many steps and current location and which keys found and which keys are left
  # from each list of paths taken, repeat for each other key (w/ duped paths)

  OPEN = "."
  WALL = "#"
  DOOR_START = "A".ord
  DOOR_END = "Z".ord
  KEY_START = "a".ord
  KEY_END = "z".ord
  KEYS_TO_FIND = (0...26).map {|i| (97+i).chr }

  attr_accessor :grid

  def initialize(file)
    @grid = File.read(file)
      .split("\n")
      .map { |line| line.split('') }
  end

  class Path
    attr_accessor :keys_found, :keys_not_found, :x, :y, :steps
    def initialize(keys_found, keys_not_found, x, y, steps)
      @keys_found = keys_found
      @keys_not_found = keys_not_found
      @x = x
      @y = y
      @steps = steps
    end

    def initialize_dup(other)
      @keys_found = other.keys_found.dup
      @keys_not_found = other.keys_not_found.dup
    end

    def to_s
      "found=#{@keys_found}, not found=#{@keys_not_found}, x=#{x}, y=#{y}, steps=#{steps}"
    end
  end

  def part1
    x, y = find_start
    keys = find_keys
    #keys_to_find = (0...26).map {|i| (97+i).chr }
    start_path = Path.new([], keys, x, y, 0)

    @counter = 0

    paths = dfs_path(start_path, "")
    binding.pry
    paths.min_by {|p| p.steps }.steps
  end

  def find_start
    (0...@grid.size).each do |y|
      (0...@grid[y].size).each do |x|
        if @grid[y][x] == "@"
          return [ x, y ]
        end
      end
    end
  end

  def find_keys
    keys = []

    (0...@grid.size).each do |y|
      (0...@grid[y].size).each do |x|
        if @grid[y][x].ord >= KEY_START && @grid[y][x].ord <= KEY_END
          keys << @grid[y][x]
        end
      end
    end

    keys
  end


  def dfs_path(path, prefix)
    #puts "check path #{path}"

    if path.keys_not_found.size == 0
      puts " winner in #{path.steps}"
      return path
    end

    @counter = @counter + 1
    #return nil if @counter > 20

    path.keys_not_found.map do |key|
      #visited = Array.new(@grid.size)
      #(0..@grid.size).each { |i| visited[i] = Array.new(@grid[0].size) }
      puts "#{prefix}#{key}"
      path_new = bfs_key(path.dup, key)
      if !path_new.nil?
        #puts "#{prefix}found path for #{key} #{path_new}"
        dfs_path(path_new, prefix + "#{key}")
      else
        #puts "#{prefix}no path for #{key}"
        nil
      end
    end.compact.flatten
  end

  def bfs_key(path, key)
    visited = Array.new(@grid.size)
    (0..@grid.size).each { |i| visited[i] = Array.new(@grid[0].size) }

    queue = []
    queue << [ path.x, path.y, 0, []]

    while !queue.empty?
      x, y, steps, found = queue[0]
      queue = queue[1,queue.length]

      type = @grid[y][x]
      #puts "check #{x}, #{y}, #{steps} #{key} #{type}"
      if visited[y][x] == true
        #puts " visited"
        next
      elsif type == key
        found << key if !found.include?(key)
        path.keys_found += found
        found.each { |k| path.keys_not_found.delete(k) }
        #puts " found #{key} for path #{path}"
        path.steps += steps
        path.x = x
        path.y = y
        return path
      elsif type == WALL
        #puts " wall"
        next
      elsif type.ord >= DOOR_START && type.ord <= DOOR_END && !path.keys_found.include?(type.downcase)
        #puts "hit wall #{type}"
        next
      else
        visited[y][x] = true

        if type.ord >= KEY_START && type.ord <= KEY_END
          found << type if !found.include?(type)
        end

        queue << [ x, y - 1, steps + 1, found.dup ]
        queue << [ x, y + 1, steps + 1, found.dup ]
        queue << [ x - 1, y, steps + 1, found.dup ]
        queue << [ x + 1, y, steps + 1, found.dup ]

        next
      end
    end
  end

end
