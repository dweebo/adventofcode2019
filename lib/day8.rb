require 'pry'
class Day8

  def initialize

  end

  WIDTH = 25
  HEIGHT = 6
  LAYERS = 100

  def part1
    file = File.read("lib/day8.txt")
    min = { "0" => 25 * 6 + 1, "1" => 0, "2" => 0 }

    (0..LAYERS).each do |layer|
      start_pos = layer * WIDTH * HEIGHT
      vals = file[start_pos, WIDTH * HEIGHT].split('')
      puts "#{start_pos} #{start_pos + WIDTH * HEIGHT}"
      g = vals.group_by {|x| x }.map {|key, list| [ key, list.size ]}.to_h
      if g.has_key?("0") && g["0"] < min["0"]
        min = g
      end
    end

    min["1"] * min["2"]
  end

  def part2
    file = File.read("lib/day8.txt")
    image = Array.new(WIDTH * HEIGHT)
    (0..WIDTH * HEIGHT - 1).each do |i|
      (0..LAYERS - 1).each do |layer|
        pos = layer * WIDTH * HEIGHT + i
        pixel = file[pos].to_i
        if pixel == 0 || pixel == 1
          image[i] = pixel
          break
        end
      end
    end

    (0..HEIGHT - 1).each do |y|
      (0..WIDTH - 1).each do |x|
        if image[y * WIDTH + x] == 0
          printf " "
        elsif image[y * WIDTH + x] == 1
          printf "1"
        else
          printf "."
        end
      end
      puts
    end

    nil
  end
end
