def fuel_req(mass)
  (mass / 3) - 2
end

def fuel_req_for_fuel(fuel)
  more_fuel = fuel_req(fuel)
  if more_fuel <= 0
    return 0
  else
    return more_fuel + fuel_req_for_fuel(more_fuel)
  end
end

part1 = File.read("lib/day1.txt")
  .split("\n")
  .map { |line| line.to_i }
  .map { |mass| fuel_req(mass) }
  .sum

puts "part1=#{part1}"

part2 = File.read("lib/day1.txt")
  .split("\n")
  .map { |line| line.to_i }
  .map { |mass| fuel_req(mass) }
  .map { |fuel| fuel + fuel_req_for_fuel(fuel) }
  .sum

puts "part2=#{part2}"
