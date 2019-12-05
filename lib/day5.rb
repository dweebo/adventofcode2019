class Day5
  attr_accessor :instructions

  OPCODE_ADD = 1
  OPCODE_MULT = 2
  OPCODE_INPUT = 3
  OPCODE_OUTPUT = 4
  OPCODE_END = 99
  FULL_OPCODE_INSTRUCTION_LEN = 5
  MAX_PARAMS = 3
  PARAM_MODE_POSITION = 0
  PARAM_MODE_IMMEDIATE = 1

  def initialize(file)
    @instructions = File.read(file).split(",").map(&:to_i)
  end

  def execute
    current_instruction = 0

    while true do

      op_code = parse_opcode(@instructions[current_instruction])
      modes = parse_modes(@instructions[current_instruction])

      if op_code == OPCODE_END
        break
      elsif op_code == OPCODE_ADD
        params = @instructions[current_instruction + 1, 3]
        values = params.zip(modes).map{ |param, mode| value(mode, param) }
        @instructions[params[2]] = values[0] + values[1]
        current_instruction += 4
      elsif op_code == OPCODE_MULT
        params = @instructions[current_instruction + 1, 3]
        values = params.zip(modes).map{ |param, mode| value(mode, param) }
        @instructions[params[2]] = values[0] * values[1]
        current_instruction += 4
      elsif op_code == OPCODE_INPUT
        puts "input: "
        addr = @instructions[current_instruction + 1]
        value = $stdin.gets
        value = value.chomp.to_i
        @instructions[addr] = value
        current_instruction += 2
      elsif op_code == OPCODE_OUTPUT
        param = @instructions[current_instruction + 1]
        value = value(modes[0], param)
        puts value(modes[0], param)
        current_instruction += 2
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

  def value(mode, param)
    if mode == PARAM_MODE_IMMEDIATE
      param
    else
      @instructions[param]
    end
  end

end
