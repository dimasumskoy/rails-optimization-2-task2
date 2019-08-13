require 'benchmark'
require_relative 'work'

def print_memory_usage
  "%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)
end

def run_benchmark
  time = Benchmark.realtime do
    puts "Memory usage on start: #{print_memory_usage}"

    Work.new(file: 'test_data.txt').perform

    puts "Memory usage on finish: #{print_memory_usage}"
  end

  puts "Finish in #{time.round(2)}"
end

run_benchmark