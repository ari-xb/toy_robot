require 'spec_helper'
require 'robot'

describe Robot do
  subject(:robot) { Robot.new }
  
  context "before a valid 'place' command is executed" do
    it 'should not have co-ordinates' do
      expect(robot.coordinates).to be_nil
    end
    
    it 'should not have a facing direction' do
      expect(robot.facing).to be_nil
    end
    
    it 'should not allow the robot to move' do
      expect { robot.execute('MOVE') }.to_not change { robot.coordinates }
    end
    
    it 'should not allow the robot to turn left' do
      expect { robot.execute('LEFT') }.to_not change { robot.facing }
    end
    
    it 'should not allow the robot to turn right' do
      expect { robot.execute('RIGHT') }.to_not change { robot.facing }
    end
    
    it 'should not allow the robot to report its position' do
      expect($stdout).to_not receive(:write)
      robot.execute('REPORT')
    end
  end
  
  context "when trying to execute a valid 'place' command" do
    it 'should not accept coordinates outside the range of the grid' do
      expect { robot.execute('PLACE 1,6,NORTH') }.to_not change { robot.coordinates }
    end
    
    it 'should not accept coordinates that are not integers' do
      expect { robot.execute('PLACE a,2,NORTH') }.to_not change { robot.coordinates }
    end
    
    it 'should not accept a direction outside of north, east, south, west' do
      expect { robot.execute('PLACE 1,1,RANDOM') }.to_not change { robot.coordinates }
    end
  end
end
