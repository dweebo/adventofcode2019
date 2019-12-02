class Day2
  attr_accessor :instructions

  def initialize(file, noun, verb)
    @instructions = File.read(file).split(",").map(&:to_i)

    @instructions[1] = noun unless noun.nil?
    @instructions[2] = verb unless verb.nil?
  end

  def execute
    current_instruction = 0

    while @instructions[current_instruction] != 99 do

      if @instructions[current_instruction] == 1
        @instructions[@instructions[current_instruction + 3]] =
          @instructions[@instructions[current_instruction + 1]] +
          @instructions[@instructions[current_instruction + 2]]
      elsif @instructions[current_instruction] == 2
        @instructions[@instructions[current_instruction + 3]] =
          @instructions[@instructions[current_instruction + 1]] *
          @instructions[@instructions[current_instruction + 2]]
      end
      current_instruction += 4
    end
  end
end
