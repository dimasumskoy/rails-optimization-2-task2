require 'ruby-prof'
require_relative 'work'

RubyProf.measure_mode = RubyProf::MEMORY

result = RubyProf.profile do
  GC.disable
  Work.new(file: 'test_data.txt').perform
end

printer = RubyProf::CallTreePrinter.new(result)
printer.print(path: 'reports', profile: 'callgrind')
