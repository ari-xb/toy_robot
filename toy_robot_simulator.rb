require_relative 'lib/input_parser'
require_relative 'lib/robot'
require_relative 'lib/facing'
require_relative 'lib/coordinate'

while input = $stdin.gets
  commands = InputParser.new.parse input
  Robot.new.execute commands
end
