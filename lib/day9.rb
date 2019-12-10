require_relative 'int_code.rb'
require 'pry'

class Day9
  def part1
    engine = IntCode.new("lib/day9.txt")
    engine.execute
  end
end
