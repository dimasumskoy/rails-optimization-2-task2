require 'benchmark'
require_relative 'work'

def print_memory_usage
  "%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)
end

puts "Memory usage on start: #{print_memory_usage}"

time = Benchmark.realtime do
  Work.new(file: 'test_data.txt').perform
end

puts "Memory usage on finish: #{print_memory_usage}"
puts "Finish in #{time.round(2)}"
