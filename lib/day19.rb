require_relative 'int_code'

class Day19

  class TractorBeam
    attr_reader :value

    def initialize(x, y)
      @x = x
      @y = y
      @reading_x = true
      @value = 0
    end

    def read
      if @reading_x
        value = @x
      else
        value = @y
      end

      @reading_x = !@reading_x

      value
    end

    def write(value)
      @value = value


      @x = @x + 1
      if @x == @width
        puts
        @x = 0
        @y = @y + 1
      end
    end
  end

  def part1
    width = 50
    height = 50
    pull_count = 0
    (0...height).each do |y|
      (0...width).each do |x|
        engine = IntCode.new('lib/day19.txt')
        beam = TractorBeam.new(x, y)
        engine.set_input_reader(beam)
        engine.set_output_writer(beam)
        engine.execute

        if (beam.value == 0)
          print "."
        else
          print "#"
          pull_count += 1
        end
      end
      puts
    end

    pull_count
  end

  def value_at(x, y)
    engine = IntCode.new('lib/day19.txt')
    beam = TractorBeam.new(x, y)
    engine.set_input_reader(beam)
    engine.set_output_writer(beam)
    engine.execute
    beam.value
  end


  def part22
    min_x = 665
    max_x = 1000
    x = min_x
    y = 1000

    while true
      puts "check #{x}, #{y}"
      if value_at(x, y) == 1 &&
         value_at(x+99, y) == 1 &&
         value_at(x, y+99) == 1
        puts "found good spot #{x}, #{y}"
        return
      end

      x = x + 1
      if x == max_x
        x = min_x
        y += 1
      end
    end

  end
end

