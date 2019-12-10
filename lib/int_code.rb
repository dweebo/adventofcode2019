require 'pry'

class IntCode
  attr_accessor :instructions

  OPCODE_ADD = 1
  OPCODE_MULT = 2
  OPCODE_INPUT = 3
  OPCODE_OUTPUT = 4
  OPCODE_JUMP_IF_TRUE = 5
  OPCODE_JUMP_IF_FALSE = 6
  OPCODE_LESS_THAN = 7
  OPCODE_EQUALS = 8
  OPCODE_ADJ_REL_BASE = 9
  OPCODE_END = 99
  FULL_OPCODE_INSTRUCTION_LEN = 5
  MAX_PARAMS = 3
  PARAM_MODE_POSITION = 0
  PARAM_MODE_IMMEDIATE = 1
  PARAM_MODE_RELATIVE = 2

  EXTRA_MEM = 2048

  class StdinInputReader
    def read
      puts "input: "
      $stdin.gets.chomp.to_i
    end
  end

  class StdoutOutputWriter
    def write(value)
      puts value
    end
  end

  def initialize(file)
    @instructions =
      File.read(file).split(",").map(&:to_i) +
      Array.new(EXTRA_MEM, 0)
    @input_reader = StdinInputReader.new
    @output_writer = StdoutOutputWriter.new
  end

  def set_input_reader(reader)
    @input_reader = reader
  end

  def set_output_writer(writer)
    @output_writer = writer
  end

  def execute
    relative_base = 0
    current_instruction = 0

    while true do

      op_code = parse_opcode(@instructions[current_instruction])
      modes = parse_modes(@instructions[current_instruction])
      #puts "op = #{op_code} #{current_instruction}"

      case op_code
      when OPCODE_END
        return
      when OPCODE_ADD
        current_instruction = add(current_instruction, relative_base, modes)
      when OPCODE_MULT
        current_instruction = mult(current_instruction, relative_base, modes)
      when OPCODE_INPUT
        current_instruction = input(current_instruction, relative_base, modes)
      when OPCODE_OUTPUT
        current_instruction = output(current_instruction, relative_base, modes)
      when OPCODE_JUMP_IF_TRUE
        current_instruction = jump_if_true(current_instruction, relative_base, modes)
      when OPCODE_JUMP_IF_FALSE
        current_instruction = jump_if_false(current_instruction, relative_base, modes)
      when OPCODE_LESS_THAN
        current_instruction = less_than(current_instruction, relative_base, modes)
      when OPCODE_EQUALS
        current_instruction = equals(current_instruction, relative_base, modes)
      when OPCODE_ADJ_REL_BASE
        current_instruction, relative_base = adjust_relative_base(current_instruction, relative_base, modes)
      end
    end
  end

  def parse_opcode(instruction)
    opcode = instruction.to_s
    opcode = opcode[opcode.length - 2, 2]
    opcode.to_i
  end

  def parse_modes(instruction)
    instruction_str = instruction.to_s
    default_modes = Array.new(MAX_PARAMS).fill(PARAM_MODE_POSITION).join('')
    missing = FULL_OPCODE_INSTRUCTION_LEN - instruction_str.length
    full_instruction = default_modes[0, missing] + instruction_str
    full_instruction[0, MAX_PARAMS]
      .split('')
      .map{ |c| c.to_i }
      .reverse
  end

  def value(mode, relative_base, param)
    if mode == PARAM_MODE_IMMEDIATE
      param
    elsif mode == PARAM_MODE_RELATIVE
      @instructions[param + relative_base]
    else
      @instructions[param]
    end
  end

  def addr(mode, relative_base, param)
    if mode == PARAM_MODE_RELATIVE
      param + relative_base
    else
      param
    end
  end

  def add(current_instruction, relative_base, modes)
    params = @instructions[current_instruction + 1, 3]
    values = params.zip(modes).map{ |param, mode| value(mode, relative_base, param) }
    output_addr = addr(modes[2], relative_base, params[2])
    @instructions[output_addr] = values[0] + values[1]
    current_instruction + 4
  end

  def mult(current_instruction, relative_base, modes)
    params = @instructions[current_instruction + 1, 3]
    values = params.zip(modes).map{ |param, mode| value(mode, relative_base, param) }
    output_addr = addr(modes[2], relative_base, params[2])
    @instructions[output_addr] = values[0] * values[1]
    current_instruction + 4
  end

  def input(current_instruction, relative_base, modes)
    param = @instructions[current_instruction + 1]
    output_addr = addr(modes[0], relative_base, param)
    value = @input_reader.read
    @instructions[output_addr] = value
    current_instruction + 2
  end

  def output(current_instruction, relative_base, modes)
    #binding.pry
    param = @instructions[current_instruction + 1]
    value = value(modes[0], relative_base, param)
    @output_writer.write(value)
    current_instruction + 2
  end

  def jump_if_true(current_instruction, relative_base, modes)
    test_value, jump_value = @instructions[current_instruction + 1, 2]
      .zip(modes)
      .map { |param, mode| value(mode, relative_base, param) }

    if test_value != 0
      jump_value
    else
      current_instruction + 3
    end
  end

  def jump_if_false(current_instruction, relative_base, modes)
    test_value, jump_value = @instructions[current_instruction + 1, 2]
      .zip(modes)
      .map { |param, mode| value(mode, relative_base, param) }

    if test_value == 0
      jump_value
    else
      current_instruction + 3
    end
  end

  def less_than(current_instruction, relative_base, modes)
    params = @instructions[current_instruction + 1, 3]
    p1, p2 = params
      .zip(modes)
      .map { |param, mode| value(mode, relative_base, param) }

    output_addr = addr(modes[2], relative_base, params[2])
    @instructions[output_addr] = (p1 < p2) ? 1 : 0

    current_instruction + 4
  end

  def equals(current_instruction, relative_base, modes)
    params = @instructions[current_instruction + 1, 3]
    p1, p2 = params
      .zip(modes)
      .map { |param, mode| value(mode, relative_base, param) }

   output_addr = addr(modes[2], relative_base, params[2])
   @instructions[output_addr] = (p1 == p2) ? 1 : 0

   current_instruction + 4
  end

  def adjust_relative_base(current_instruction, relative_base, modes)
    param = @instructions[current_instruction + 1]
    mode = modes[0]
    adj = value(mode, relative_base, param)

    relative_base += adj
    current_instruction += 2

    [ current_instruction, relative_base ]
  end
end
