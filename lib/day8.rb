require 'pry'
class Day8

  def initialize

  end

  def execute
    file = File.read("lib/day8.txt")
    width = 25
    height = 6
    layers = 100
    min = { "0" => 25 * 6 + 1, "1" => 0, "2" => 0 }

    (0..layers).each do |layer|
      start_pos = layer * width * height
      vals = file[start_pos, width * height].split('')
      puts "#{start_pos} #{start_pos + width * height}"
      g = vals.group_by {|x| x }.map {|key, list| [ key, list.size ]}.to_h
      if g.has_key?("0") && g["0"] < min["0"]
        puts " new min #{g["0"]} #{layer}"
        min = g
      end
    end

    min["1"] * min["2"]
  end
end
