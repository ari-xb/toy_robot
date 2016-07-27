require 'spec_helper'
require 'input_parser'
require 'robot'
require 'facing'
require 'coordinate'

describe Robot do
  let(:parser) { InputParser.new }
  subject(:robot) { Robot.new }
  
  context "before a valid 'place' command is executed" do
    it 'should not have co-ordinates' do
      expect(robot.coordinates).to be_nil
    end
    
    it 'should not have a facing direction' do
      expect(robot.facing).to be_nil
    end
    
    it 'should not be allowed to move' do
      commands = parser.parse('MOVE')
      expect { robot.execute commands }.to_not change { robot.coordinates }
    end
    
    it 'should not be allowed to turn left' do
      commands = parser.parse('LEFT')
      expect { robot.execute commands }.to_not change { robot.facing }
    end
    
    it 'should not be allowed to turn right' do
      commands = parser.parse('RIGHT')
      expect { robot.execute commands }.to_not change { robot.facing }
    end
    
    it 'should not be allowed to report its position' do
      expect($stdout).to_not receive(:write)
      commands = parser.parse('REPORT')
      robot.execute commands
    end
  end
  
  context "when trying to execute a valid 'place' command" do
    it 'should not be placed when the coordinates are outside the range of the grid' do
      commands = parser.parse('PLACE 1,6,NORTH')
      expect { robot.execute commands }.to_not change { robot.coordinates }
    end
    
    it 'should not accept coordinates that are not integers' do
      commands = parser.parse('PLACE a,2,NORTH')
      expect { robot.execute commands }.to_not change { robot.coordinates }
    end
    
    it 'should not accept a direction outside of north, east, south, west' do
      commands = parser.parse('PLACE 1,1,RANDOM')
      expect { robot.execute commands }.to_not change { robot.coordinates }
    end
    
    it 'should be placed on the grid when the coordinates and direction are valid' do
      commands = parser.parse('PLACE 1,2,NORTH')
      expect { robot.execute commands }.to change { robot.coordinates }
    end
  end
  
  context "after a valid 'place' command is executed" do
    # Place
    it 'should be able to be placed again' do
      commands = parser.parse('PLACE 1,2,NORTH MOVE PLACE 2,3,SOUTH')
      robot.execute commands
      expect(robot.coordinates.y).to eq(3)
    end
    
    # Random Commands
    it 'should ignore commands other than place, move, left, right and report' do
      commands = parser.parse('PLACE 1,3,NORTH RANDOM MOVE')
      robot.execute commands
      expect(robot.coordinates.y).to eq(4)
    end
    
    # Report
    it 'should be able to report its position' do
      expect($stdout).to receive(:write)
      commands = parser.parse('PLACE 1,2,NORTH REPORT')
      robot.execute commands
    end
    
    # Left Turn
    it 'should change its facing direction from north to west when turning left' do
      command = parser.parse('PLACE 1,2,NORTH')
      robot.execute command
      command = parser.parse('LEFT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:north).to(:west)
    end
    
    it 'should change its facing direction from west to south when turning left' do
      command = parser.parse('PLACE 1,2,WEST')
      robot.execute command
      command = parser.parse('LEFT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:west).to(:south)
    end
    
    it 'should change its facing direction from south to east when turning left' do
      command = parser.parse('PLACE 1,2,SOUTH')
      robot.execute command
      command = parser.parse('LEFT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:south).to(:east)
    end
    
    it 'should change its facing direction from east to north when turning left' do
      command = parser.parse('PLACE 1,2,EAST')
      robot.execute command
      command = parser.parse('LEFT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:east).to(:north)
    end
    
    # Right Turn
    it 'should change its facing direction from north to east when turning right' do
      command = parser.parse('PLACE 1,2,NORTH')
      robot.execute command
      command = parser.parse('RIGHT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:north).to(:east)
    end
    
    it 'should change its facing direction from east to south when turning right' do
      command = parser.parse('PLACE 1,2,EAST')
      robot.execute command
      command = parser.parse('RIGHT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:east).to(:south)
    end
    
    it 'should change its facing direction from south to west when turning right' do
      command = parser.parse('PLACE 1,2,SOUTH')
      robot.execute command
      command = parser.parse('RIGHT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:south).to(:west)
    end
    
    it 'should change its facing direction from west to north when turning right' do
      command = parser.parse('PLACE 1,2,WEST')
      robot.execute command
      command = parser.parse('RIGHT')
      expect { robot.execute command }.to change { robot.facing.direction }.from(:west).to(:north)
    end
    
    # Move
    context "when a 'move' command is issued" do
      it 'should move north when facing north' do
        command = parser.parse('PLACE 1,2,NORTH')
        robot.execute command
        command = parser.parse('MOVE')
        expect { robot.execute command }.to change { robot.coordinates.y }.by(1)
      end
      
      it 'should move east when facing east' do
        command = parser.parse('PLACE 1,2,EAST')
        robot.execute command
        command = parser.parse('MOVE')
        expect { robot.execute command }.to change { robot.coordinates.x }.by(1)
      end
      
      it 'should move south when facing south' do
        command = parser.parse('PLACE 1,2,SOUTH')
        robot.execute command
        command = parser.parse('MOVE')
        expect { robot.execute command }.to change { robot.coordinates.y }.by(-1)
      end
      
      it 'should move west when facing west' do
        command = parser.parse('PLACE 1,2,WEST')
        robot.execute command
        command = parser.parse('MOVE')
        expect { robot.execute command }.to change { robot.coordinates.x }.by(-1)
      end
      
      context 'when the robot is on the edge of the grid' do
        it 'should not be able to move north when its at the northern most point in the grid' do
          command = parser.parse('PLACE 2,5,NORTH')
          robot.execute command
          command = parser.parse('MOVE')
          expect { robot.execute command }.to_not change { robot.coordinates.y }
        end
        
        it 'should not be able to move east when its at the eastern most point in the grid' do
          command = parser.parse('PLACE 5,3,EAST')
          robot.execute command
          command = parser.parse('MOVE')
          expect { robot.execute command }.to_not change { robot.coordinates.x }
        end
        
        it 'should not be able to move south when its at the southern most point in the grid' do
          command = parser.parse('PLACE 3,0,SOUTH')
          robot.execute command
          command = parser.parse('MOVE')
          expect { robot.execute command }.to_not change { robot.coordinates.y }
        end
        
        it 'should not be able to move west when its at the western most point in the grid' do
          command = parser.parse('PLACE 0,3,WEST')
          robot.execute command
          command = parser.parse('MOVE')
          expect { robot.execute command }.to_not change { robot.coordinates.x }
        end
      end
    end
  end
end
