require_relative 'profilers'
require 'open3'

puts 'Running tests'
stdout = Open3.capture3('ruby minitest/test_me.rb')
puts stdout

puts 'Starting benchmark'
run_benchmark
puts 'Done'

# puts 'Starting profiler'
# run_memory_profiler
# puts 'Done'

puts 'Starting ruby-prof'
run_ruby_prof_flat
puts 'Done'

puts 'Finish'
