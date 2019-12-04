class Day4

  def initialize(start_range, end_range)
    @start_range = start_range
    @end_range = end_range
  end

  def valid_passwords
    (@start_range..@end_range).select do |possible_pass|
      check_increasing(possible_pass) && check_double(possible_pass)
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


end
