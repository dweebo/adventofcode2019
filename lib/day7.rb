require_relative 'int_code.rb'

class Day7
  include Process

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

  class WrappedReader
    def initialize(base)
      @base = base
    end

    def read
      x = @base.gets
      puts "read #{x}"
      x.chomp.to_i
    end

    def eof?
      @base.eof?
    end
  end

  class WrappedWriter
    def initialize(base, info)
      @base = base
      @info = info
    end

    def write(value)
      puts "#{@info} writer #{value}"
      @base.puts(value)
    end

    def close
      puts "#{@info} writer close"
      @base.close
    end
  end

  class MultiWriter
    def initialize(writers)
      @writers = writers
    end

    def write(value)
      puts "multi write #{value}"
      @writers.each do |w|
        w.write(value)
      end
    end

    def close
      @writers.each do |w|
        w.close
      end
    end
  end

  def part1()

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

      chained_input = check_thrust_part1(inputs)

      if chained_input > max_signal
        max_signal = chained_input
      end

    end end end end end

    puts max_signal
  end

  def check_thrust_part1(inputs)
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

  def part2()

    max_signal = 0

    (5..9).each do |i|
    (5..9).each do |j|
    (5..9).each do |k|
    (5..9).each do |l|
    (5..9).each do |m|

      inputs = [ i, j, k, l, m ]
      if inputs.uniq.size < 5
        next
      end

      puts "check #{inputs}"
      chained_input = check_thrust_part2(inputs)

      if chained_input > max_signal
        puts "new max #{chained_input}"
        max_signal = chained_input
      end

    end end end end end

    puts "max signal=#{max_signal}"
    max_signal
  end

  def pipe(info)
    r, w = IO.pipe
    { r: WrappedReader.new(r), w: WrappedWriter.new(w, info) }
  end

  # need to run all engines at the same time so they can pass inputs/outputs?
  # and have blocking io
  # and need way to wire up input/output
  # ends when final engine is done, how to get that output?
  # create 5 threads and 5 engines
  # create input/output for 1-2, 2-3, 3-4, 4-5, 5-1
  # create a stdout writer for last engine
  # allow multiple outputs
  def check_thrust_part2(inputs)
    engines = (0..4).map { IntCode.new("lib/day7.txt") }

    pipes = []
    (0..4).each do |i|
      pipes << pipe(i)
      engines[i].set_output_writer(pipes[i][:w])
      engines[(i + 1) % 5].set_input_reader(pipes[i][:r])
      pipes[i][:w].write(inputs[(i + 1) % 5])
    end

    final_pipe = pipe("final")
    final_writer = MultiWriter.new([ final_pipe[:w], pipes[4][:w] ])
    pipes[4][:w] = final_writer
    engines[4].set_output_writer(final_writer)

    final_writer.write(0)

    pids = []
    (0..4).each do |i|
      pids << fork {
        engines[i].execute
      }
    end

    # close all writers in parent process
    (0..4).each do |i|
      pipes[i][:w].close
    end

    pids.each do |pid|
      waitpid(pid, 0)
    end

    while !final_pipe[:r].eof?
      final_value = final_pipe[:r].read
    end

    final_value

  end

end
