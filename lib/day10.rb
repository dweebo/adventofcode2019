require 'pry'

class Day10

  # find asteroids into list of coords
  # for each asteroid
  #   find polar angles to all other asteroids and put in set
  #    or slope?
  #   if set.size > max
  #     max = set.size
  # return max
  def part1(file)
    map = File.read(file).split("\n").map{ |line| line.split('') }
    asteroids = find_asteroids(map)
    max_sight = 0
    asteroids.each do |asteroid1|
      angles = Set[]
      asteroids.each do |asteroid2|
        next if asteroid1 == asteroid2
        angles << polar_angle(asteroid1, asteroid2)
      end
      if angles.size > max_sight
        max_sight = angles.size
      end
    end

    max_sight
  end

  def find_asteroids(map)
    asteroids = []

    rows = map.size
    cols = map[0].size
    (0...rows).each do |y|
      (0..cols).each do |x|
        if map[y][x] == '#'
          asteroids << [ x, y ]
        end
      end
    end

    asteroids
  end

  def polar_angle(asteroid1, asteroid2)
    x = asteroid2[0] - asteroid1[0]
    y = asteroid2[1] - asteroid1[1]
    Math.atan2(y, x)
  end
end
