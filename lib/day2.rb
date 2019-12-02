class Day2
  attr_reader :instructions

  def initialize(file)
    @instructions = File.read(file).split(",")
  end

  def execute
  end
end
