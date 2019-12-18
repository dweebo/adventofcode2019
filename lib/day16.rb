class Day16

  def part1(file)
    sequence = File.read(file).chomp.split('').map(&:to_i)
    patterns = build_patterns(sequence.size)
    phases = 100

    phases.times do |phase|
      sequence = patterns.map do |pattern|
        (sequence.zip(pattern).map{ |s, p| s*p }.sum).abs % 10
      end
    end

    sequence[0, 8].join('').to_i

  end

  def build_patterns(len)
    base_pattern = [ 0, 1, 0, -1 ]
    (1..len).map do |i|
      x = []
      base_pattern.each do |p|
        (1..i).each do |j|
          x << p
        end
      end
      while x.length < len + 1
        x = x + x
      end
      x[1, len]
    end
  end
end
