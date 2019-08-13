require 'ruby-prof'
require 'memory_profiler'
require 'benchmark'

require_relative 'work'

TEST_FILE = 'test_data.txt'.freeze

def run_ruby_prof_flat
  RubyProf.measure_mode = RubyProf::ALLOCATIONS

  result = RubyProf.profile do
    GC.disable
    Work.new(file: TEST_FILE).perform
  end

  printer = RubyProf::FlatPrinter.new(result)
  printer.print(File.open('reports/flat.txt', 'w+'))

  printer = RubyProf::GraphHtmlPrinter.new(result)
  printer.print(File.open('reports/graph.html', 'w+'))

  printer = RubyProf::CallStackPrinter.new(result)
  printer.print(File.open('reports/callstack.html', 'w+'))
end

def run_ruby_prof_callgrind
  RubyProf.measure_mode = RubyProf::MEMORY

  result = RubyProf.profile do
    GC.disable
    Work.new(file: TEST_FILE).perform
  end

  printer = RubyProf::CallTreePrinter.new(result)
  printer.print(path: 'reports', profile: 'callgrind')
end

def run_memory_profiler
  report = MemoryProfiler.report do
    Work.new(file: TEST_FILE).perform
  end

  report.pretty_print(to_file: 'reports/memory_profiler.out', scale_bytes: true)
end

def print_memory_usage
  "%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i / 1024)
end

def run_benchmark
  time = Benchmark.realtime do
    puts "Memory usage on start: #{print_memory_usage}"

    Work.new(file: TEST_FILE).perform

    puts "Memory usage on finish: #{print_memory_usage}"
  end

  puts "Finish in #{time.round(2)}"
end
