require_relative 'int_code.rb'

class Day7

  class ArrayInputReader
    def initialize(inputs)
      @inputs = inputs
    end

    def read
      @inputs.shift
    end
  end

  class ValueOutputWriter
    attr_reader :value
    def write(value)
      @value = value
    end
  end

  def execute()

    max_signal = 0

    (0..4).each do |i|
    (0..4).each do |j|
    (0..4).each do |k|
    (0..4).each do |l|
    (0..4).each do |m|

      inputs = [ i, j, k, l, m ]
      if inputs.uniq.size < 5
        next
      end

      chained_input = check_thrust(inputs)

      if chained_input > max_signal
        max_signal = chained_input
      end

    end end end end end

    puts max_signal
  end

  def check_thrust(inputs)
    chained_input = 0
    inputs.each do |phase_setting|
      writer = ValueOutputWriter.new
      reader = ArrayInputReader.new([ phase_setting, chained_input ])

      engine = IntCode.new("lib/day7.txt")
      engine.set_input_reader(reader)
      engine.set_output_writer(writer)
      engine.execute
      chained_input = writer.value
    end
    chained_input
  end

end
