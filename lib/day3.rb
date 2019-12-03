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
                      0)
      end
    when "L"
      (1..distance).map do |i|
        WirePoint.new(current_point.x - i,
                      current_point.y,
                      0)
      end
    when "U"
      (1..distance).map do |i|
        WirePoint.new(current_point.x,
                      current_point.y - i,
                      0)
      end
    when "D"
      (1..distance).map do |i|
        WirePoint.new(current_point.x,
                      current_point.y + i,
                      0)
      end
    end
  end
end
