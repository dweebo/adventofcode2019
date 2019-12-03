class Day3

  class WirePoint
    attr_accessor :x, :y, :steps
    def initialize(x = 0, y = 0, steps = 0)
      @x = x
      @y = y
      @steps = steps
    end

    def eql?(other)
      x == other.x && y == other.y
    end

    def hash
      [x, y].hash
    end

    def to_s
      "#{x},#{y} steps=#{steps}"
    end
  end

  def initialize(file)
    data = File.read(file)
    @wire1, @wire2 = data.split("\n").map{|wire| wire.split(",") }
  end

  def part1
    (lay_wire(@wire1) & lay_wire(@wire2))
      .map { |intersection| intersection.x.abs + intersection.y.abs }
      .min
  end

  def part2
    wire1_coords = lay_wire(@wire1)
    wire2_coords = lay_wire(@wire2)
    min_steps = 1000000
    wire1_coords.each do |w1|
      wire2_coords.each do |w2|
        if w1.eql?(w2)
          steps = w1.steps + w2.steps
          if steps < min_steps
            min_steps = steps
          end
        end
      end
    end
    return min_steps
  end

  def lay_wire(wire)
    coords = Set[]
    current_point = WirePoint.new
    wire.map do |instruction|
      new_coords = move(current_point, instruction)
      current_point = new_coords.last
      coords += new_coords
    end
    coords
  end

  def move(current_point, instruction)
    direction = instruction[0]
    distance = instruction[1, instruction.length].to_i
    case direction
    when "R"
      (1..distance).map do |i|
        WirePoint.new(current_point.x + i,
                      current_point.y,
                      current_point.steps + i)
      end
    when "L"
      (1..distance).map do |i|
        WirePoint.new(current_point.x - i,
                      current_point.y,
                      current_point.steps + i)
      end
    when "U"
      (1..distance).map do |i|
        WirePoint.new(current_point.x,
                      current_point.y - i,
                      current_point.steps + i)
      end
    when "D"
      (1..distance).map do |i|
        WirePoint.new(current_point.x,
                      current_point.y + i,
                      current_point.steps + i)
      end
    end
  end
end
