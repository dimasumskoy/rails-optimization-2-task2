require 'memory_profiler'
require_relative 'work.rb'

def run_profiler
  report = MemoryProfiler.report do
    Work.new(file: 'test_data.txt').perform
  end

  report.pretty_print(to_file: 'reports/memory_profiler.out', scale_bytes: true)
end
