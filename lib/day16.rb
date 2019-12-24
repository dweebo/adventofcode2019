require 'pry'
class Day16

  def part1(file)
    sequence = File.read(file).chomp.split('').map(&:to_i)
    phases = 100

    phases.times do |phase|
      sequence = (1..sequence.size).map do |i|
        pattern = build_pattern(sequence.size, i)
         (sequence.zip(pattern).map{ |s, p| s*p }.sum).abs % 10
      end
    end

    #sequence[0, 8].join('').to_i
    sequence

  end

  # last digit n is always same
  # n-1 digit is (digit[n-1] + digit[10]) % 10
  # n-2 digit is (digit[n-2] + digit[n-1] + digit[10]) % 10
  # ...for 2nd half.  can build 2nd half in linear time
  # 2nd quarter is similar, have to add more than 1 number from previous but still
  # maybe to generalize, build up a list of transitions for each digit
  #  n-1=[n-1]
  #  n-2=[n-2]
  #  n/2-1=[n/2-1, -n]
  #  n/2-2=[n/2-2, -n-1, -n-2]
  #  n/2-3=[n/2-3, -n-3, -n-4]
  #  n/2-4=[n/2-4, -n-5, -n-6, -n, -n-1]
  def part1_pattern_diff(file)
    sequence = File.read(file).chomp.split('').map(&:to_i) * 2
    #sequence = File.read(file).chomp.split('').map(&:to_i)
    phases = 1
    t=Time.now
    puts "start calc pattern diff"
    pd = patterns_diff(sequence.size)
    puts "end calc pattern diff in #{Time.now - t} size=#{pd.flatten.size/2}"
    phases.times do |phase|
      #puts "phase #{phase}: sequence = #{sequence.join('')}"
      old_sequence=sequence.dup
      (2..sequence.size).each do |i|
        i = sequence.size - i
        new_value = sequence[i+1]
        diff = pd[i].map do |di, m|
          old_sequence[di] * m
        end.sum
        new_value = (new_value + diff)

        sequence[i] = new_value
      end
      (0...sequence.size).each do |i|
        sequence[i] = sequence[i].abs % 10
      end
    end

    #sequence[0, 8].join('').to_i
    sequence.join('').to_i


  end
#12345678
  #       8

  def part2_perf_hack(file)
    sequence = File.read(file).chomp.split('').map(&:to_i) * 10000
    #sequence = File.read(file).chomp.split('').map(&:to_i)
    phases = 100

    base_pattern = [ 0, 1, 0, -1 ]
    t = Time.now
    phases.times do |phase|
      puts "start phase #{phase}"
      sequence = (1..sequence.size).map do |i|
        #a=Time.now
        total = 0
        pattern_index=(i==1)?1:0
        pattern_count=0
        pattern_size=i
        s=true
        if i%1000==0
          puts "#{i} in #{Time.now-t}"
        end
        sequence.each do |seq|
          #print "#{base_pattern[pattern_index]}*#{seq} #{pattern_index},#{pattern_count},#{pattern_size},s=#{s} "
          #print "#{base_pattern[pattern_index]}*#{seq} "
          total += base_pattern[pattern_index] * seq
          pattern_count += 1
          if pattern_size == 1 || (s && pattern_count == pattern_size - 1) || pattern_count == pattern_size
            s = false
            pattern_index = (pattern_index + 1) % base_pattern.size
            pattern_count = 0
          end
        end

        x = total.abs % 10
        #puts "#{i}=#{x}"
        #puts " done in #{Time.now - t}"
        x
      end
    end

    sequence[0, 8].join('').to_i

  end

  #0,1,0,-1
  #len=8
  #calculating digit 2
  #on 2nd digit
  #so pattern is 0, 1, 1, 0, 0, -1, -1, 0
  #so we want       X = 1

  def build_pattern(len, phase)
    #puts "build pattern #{len} #{phase}"
    base_pattern = [ 0, 1, 0, -1 ]
    x = []
    base_pattern.each do |p|
      x = x + Array.new(phase, p)
      #(1..phase).each do |j|
      #  x << p
      #end
    end
    while x.length < len + 1
      x = x + x
    end
    x[1, len]
  end

  def patterns_debug(len)
    (1..len).each do |l|
      p = build_pattern(len, l)
      p.each do |x|
        print " " if x != -1
        print "#{x}"
      end
      puts
    end
  end

  def patterns_diff(len)
    (1...len).map do |i|
        puts "#{i}"
      p1 = build_pattern(len, i)
      p2 = build_pattern(len, i + 1)
      pattern_diff(p1, p2)
    end
  end

  def pattern_diff(pattern1, pattern2)
    r = []
    (0...pattern1.size).each do |i|
      diff = pattern1[i] - pattern2[i]
      if diff != 0
        r << [ i, diff ]
      end
    end
    r
  end
end
