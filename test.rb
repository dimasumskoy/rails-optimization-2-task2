require 'open3'

require_relative 'memory_benchmark'
require_relative 'memory_profiler'
require_relative 'work_ruby_prof'

puts 'Running tests'
stdout = Open3.capture3('ruby minitest/test_me.rb')
puts stdout

puts 'Starting benchmark'
run_benchmark
puts 'Done'

# puts 'Starting profiler'
# run_profiler
# puts 'Done'

puts 'Starting ruby-prof'
run_ruby_prof
puts 'Done'

puts 'Finish'
