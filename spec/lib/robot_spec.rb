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
    it 'should not be placed when the coordinates are outside the range of the grid' do
      expect { robot.execute('PLACE 1,6,NORTH') }.to_not change { robot.coordinates }
    end
    
    it 'should not accept coordinates that are not integers' do
      expect { robot.execute('PLACE a,2,NORTH') }.to_not change { robot.coordinates }
    end
    
    it 'should not accept a direction outside of north, east, south, west' do
      expect { robot.execute('PLACE 1,1,RANDOM') }.to_not change { robot.coordinates }
    end
    
    it 'should be placed on the grid when the coordinates and direction are valid' do
      expect { robot.execute('PLACE 1,2,NORTH') }.to change { robot.coordinates }
    end
  end
  
  context "after a valid 'place' command is executed" do
    # Left Turn
    it 'should change its facing direction from north to west when turning left' do
      place = "PLACE 1,2,NORTH"
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('north').to('west')
    end
    
    it 'should change its facing direction from west to south when turning left' do
      place = "PLACE 1,2,WEST"
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('west').to('south')
    end
    
    it 'should change its facing direction from south to east when turning left' do
      place = "PLACE 1,2,SOUTH"
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('south').to('east')
    end
    
    it 'should change its facing direction from east to north when turning left' do
      place = "PLACE 1,2,EAST"
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('east').to('north')
    end
    
    # Right Turn
    it 'should change its facing direction from north to east when turning right' do
      place = "PLACE 1,2,NORTH"
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('north').to('east')
    end
    
    it 'should change its facing direction from east to south when turning right' do
      place = "PLACE 1,2,EAST"
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('east').to('south')
    end
    
    it 'should change its facing direction from south to west when turning right' do
      place = "PLACE 1,2,SOUTH"
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('south').to('west')
    end
    
    it 'should change its facing direction from west to north when turning right' do
      place = "PLACE 1,2,WEST"
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('west').to('north')
    end
  end
end
