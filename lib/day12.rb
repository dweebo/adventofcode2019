require 'pry'

class Day12
  class Point3D
    attr_accessor :x, :y, :z
    def initialize(x = 0, y = 0, z = 0)
      @x = x
      @y = y
      @z = z
    end

    def g(c1, c2)
      case
      when c1 == c2
        0
      when c1 > c2
        -1
      when c1 < c2
        1
      end
    end

    def gravity(other)
      Point3D.new(g(x, other.x),
                  g(y, other.y),
                  g(z, other.z))
    end

    def +(other)
      Point3D.new(x + other.x,
                  y + other.y,
                  z + other.z)
    end

    def sum
      x.abs + y.abs + z.abs
    end

    def to_s
      "x=#{x} y=#{y} z=#{z}"
    end

    def hash
      [ x, y ,z ].hash
    end

    def to_a
      [ x, y, z ]
    end
  end

  EXAMPLE_ONE = [
    Moon.new(-1, 0, 2),
    Moon.new(2, -10, -7),
    Moon.new(4, -8, 8),
    Moon.new(3, 5, -1)
  ]
  INPUT = [
    Moon.new(-19, -4, 2),
    Moon.new(-9, 8, -16),
    Moon.new(-4, 5, -11),
    Moon.new(1, 9, -13)
  ]

  class Moon
    attr_accessor :position, :velocity, :velocity_change

    def initialize(x, y, z)
      @position = Point3D.new(x, y, z)
      @velocity = Point3D.new
      @velocity_change = Point3D.new
    end

    def adjust_state
      @velocity += @velocity_change
      @position += @velocity
      @velocity_change = Point3D.new(0, 0, 0)
    end

    def energy
      @position.sum * @velocity.sum
    end

    def hash
      [ @position, @velocity ].hash
    end

    def to_s
      "pos=<#{position}>, vel=<#{velocity}>"
    end

    def to_a
      @position.to_a + @velocity.to_a
    end
  end

  def part1(moons = INPUT, turns = 1000)
    (0...turns).each do |turn|
      (0...4).each do |i|
        ((i + 1)...4).each do |j|
          moons[i].velocity_change += (moons[i].position.gravity(moons[j].position))
          moons[j].velocity_change += (moons[j].position.gravity(moons[i].position))
        end
      end


      moons.each do |moon|
        moon.adjust_state
        #print_state(moons, turn)
      end
    end

    moons.map {|moon| moon.energy}.sum
  end

  # does it have to return to first position before any others?
  # would think no, so would have to check all
  # if knew it would be first position we had to find
  # 57,473,000 in something like 30 min
  def part2(moons = INPUT, turns = 3000)
    seen = {}

    (0...turns).each do |turn|
      (0...4).each do |i|
        ((i + 1)...4).each do |j|
          moons[i].velocity_change += (moons[i].position.gravity(moons[j].position))
          moons[j].velocity_change += (moons[j].position.gravity(moons[i].position))
        end
      end

      moons.each do |moon|
        moon.adjust_state
        #print_state(moons, turn)
      end

      hash = moons.map(&:to_a).reduce(&:+).hash
      if seen.has_key?(hash)
        puts "seen in #{turn} turns"
        return
      end
      seen[hash] = 1
      #print_state(moons, turn)
      if turn % 1000 == 0
        puts "#{turn}"
      end
    end


  end

  def print_state(moons, turn)
    puts "turn #{turn}"
    moons.each do |moon|
      moon.adjust_state
      puts "#{moon}"
    end
    puts
  end
end
