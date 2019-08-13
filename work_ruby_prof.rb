require 'ruby-prof'
require_relative 'work'

RubyProf.measure_mode = RubyProf::ALLOCATIONS

def run_ruby_prof
  result = RubyProf.profile do
    GC.disable
    Work.new(file: 'test_data.txt').perform
  end

  printer = RubyProf::FlatPrinter.new(result)
  printer.print(File.open('reports/flat.txt', 'w+'))

  printer = RubyProf::GraphHtmlPrinter.new(result)
  printer.print(File.open('reports/graph.html', 'w+'))

  printer = RubyProf::CallStackPrinter.new(result)
  printer.print(File.open('reports/callstack.html', 'w+'))
end
