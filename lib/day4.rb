class Day4

  def initialize(start_range, end_range)
    @start_range = start_range
    @end_range = end_range
  end

  def part1
    (@start_range..@end_range).select do |possible_pass|
      check_increasing(possible_pass) && check_double(possible_pass)
    end.count
  end

  def part2
    (@start_range..@end_range).select do |possible_pass|
      check_increasing(possible_pass) && check_double_part2(possible_pass)
    end.count
  end

  def check_increasing(possible_pass)
    t = possible_pass.to_s
    (0..t.length-2).each do |i|
      if t[i] > t[i+1]
        return false
      end
    end
    return true
  end

  def check_double(possible_pass)
    t = possible_pass.to_s
    (0..t.length-2).each do |i|
      if t[i] == t[i+1]
        return true
      end
    end
    return false
  end

  def check_double_part2(possible_pass)
    t = possible_pass.to_s
    i = 0
    while i < (t.length - 1)
      count = 1
      while i < (t.length - 1) && t[i] == t[i + 1]
        i = i + 1
        count = count + 1
      end
      if count == 2
        return true
      end
      i = i + 1
    end

    return false
  end
end
