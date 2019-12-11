require 'pry'

class Day10

  class Asteroid
    attr_accessor :x, :y, :polar_angle, :distance

    def initialize(x:, y:)
      @x = x
      @y = y
    end

    def to_s
      "[#{x}, #{y}] @=#{polar_angle} dist=#{distance}"
    end
  end

  # find asteroids into list of coords
  # for each asteroid
  #   find polar angles to all other asteroids and put in set
  #   if set.size > max
  #     max = set.size
  # return max
  def part1(file)
    map = File.read(file).split("\n").map{ |line| line.split('') }
    asteroids = find_asteroids(map)
    max_sight = 0
    best_asteroid = nil
    asteroids.each do |asteroid1|
      angles = Set[]
      asteroids.each do |asteroid2|
        next if asteroid1 == asteroid2
        angles << polar_angle(asteroid1, asteroid2)
      end
      if angles.size > max_sight
        max_sight = angles.size
        best_asteroid = asteroid1
      end
    end

    [ max_sight, best_asteroid ]
  end

  def find_asteroids(map)
    asteroids = []

    rows = map.size
    cols = map[0].size
    (0...rows).each do |y|
      (0..cols).each do |x|
        if map[y][x] == '#'
          asteroids << Asteroid.new(x: x, y: y)
        end
      end
    end

    asteroids
  end

  def polar_angle(asteroid1, asteroid2)
    x_diff = asteroid2.x - asteroid1.x
    y_diff = asteroid2.y - asteroid1.y
    Math.atan2(x_diff, y_diff)
  end

  def distance(asteroid1, asteroid2)
    x_diff = asteroid2.x - asteroid1.x
    y_diff = asteroid2.y - asteroid1.y
    Math.sqrt(x_diff * x_diff + y_diff * y_diff)
  end

  def part2(file)
    _, best_asteroid = part1(file)
    map = File.read(file).split("\n").map{ |line| line.split('') }

    asteroids = find_asteroids(map).reject {|asteroid| asteroid.x == best_asteroid.x && asteroid.y == best_asteroid.y }

    asteroids.each do |asteroid|
      asteroid.distance = distance(best_asteroid, asteroid)
      asteroid.polar_angle = polar_angle(best_asteroid, asteroid)
    end

    asteroids = asteroids.sort_by{ |asteroid| [-asteroid.polar_angle, asteroid.distance] }

    last_angle = 0
    start = true
    vaporized_count = 0
    asteroid_index = 0
    while asteroids.length > 0
      asteroid = asteroids[asteroid_index]
      if start || last_angle != asteroid.polar_angle
        vaporized_count += 1
        asteroids.delete_at(asteroid_index)
        if asteroid_index == asteroids.length - 1
          start = true
          asteroid_index = 0
        else
          start = false
          last_angle = asteroid.polar_angle
        end
        if (vaporized_count == 200)
          return asteroid.x * 100 + asteroid.y
        end
      else
        asteroid_index = (asteroid_index + 1) % asteroids.length
      end
    end
  end
end
