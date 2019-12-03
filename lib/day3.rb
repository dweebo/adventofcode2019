class Day3

  def initialize(file)
    data = File.read(file)
    @wire1, @wire2 = data.split("\n").map{|wire| wire.split(",") }
  end

  def part1
    (lay_wire(wire1) & lay_wire(wire2))
      .map { |intersection| intersection[0].abs + intersection[1].abs }
      .min
  end

  def lay_wire(wire)
    coords = Set[]
    current_point = [0, 0]
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
      (1..distance).map {|i| [ current_point[0] + i,
                               current_point[1] ] }
    when "L"
      (1..distance).map {|i| [ current_point[0] - i,
                               current_point[1] ] }
    when "U"
      (1..distance).map {|i| [ current_point[0],
                               current_point[1] - i ] }
    when "D"
      (1..distance).map {|i| [ current_point[0],
                               current_point[1] + i ] }
    end
  end
end
