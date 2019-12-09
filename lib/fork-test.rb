def fork_test
  r, w = IO.pipe

if fork
  w.close
  (0...10).each do |i|
    sleep 1
    x = r.gets
    puts "read #{x}"
  end

  r.close
else
  r.close
  (0...10).each do |i|
    w.puts(i.to_s)
    w.flush
    sleep 1
    puts "wrote #{i}"
  end
  w.close
end
puts "done"

end

def fork_test2
  r, w = IO.pipe

  fork {
    puts "in fork"
    w.close

    (0...10).each do |i|
      sleep 1
      x = r.gets
      puts "read #{x}"
    end

    r.close
  }
  puts "in parent process"

  r.close
  (0...10).each do |i|
    w.puts(i.to_s)
    w.flush
    sleep 1
    puts "wrote #{i}"
  end
  w.close
  puts "done"

end


fork_test2
