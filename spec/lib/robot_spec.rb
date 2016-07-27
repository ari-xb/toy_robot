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
    
    it 'should not be allowed to move' do
      expect { robot.execute('MOVE') }.to_not change { robot.coordinates }
    end
    
    it 'should not be allowed to turn left' do
      expect { robot.execute('LEFT') }.to_not change { robot.facing }
    end
    
    it 'should not be allowed to turn right' do
      expect { robot.execute('RIGHT') }.to_not change { robot.facing }
    end
    
    it 'should not be allowed to report its position' do
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
    # Place
    it 'should be able to be placed again' do
      robot.execute('PLACE 1,2,NORTH MOVE PLACE 2,3,SOUTH REPORT')
      expect(robot.coordinates.y).to eq(3)
    end
    
    # Random Commands
    it 'should ignore commands other than place, move, left, right and report' do
      robot.execute('PLACE 1,3,NORTH RANDOM MOVE REPORT')
      expect(robot.coordinates.y).to eq(4)
    end
    
    # Report
    it 'should be able to report its position' do
      expect($stdout).to receive(:write)
      robot.execute('PLACE 1,2,NORTH REPORT')
    end
    
    # Left Turn
    it 'should change its facing direction from north to west when turning left' do
      place = 'PLACE 1,2,NORTH'
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('north').to('west')
    end
    
    it 'should change its facing direction from west to south when turning left' do
      place = 'PLACE 1,2,WEST'
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('west').to('south')
    end
    
    it 'should change its facing direction from south to east when turning left' do
      place = 'PLACE 1,2,SOUTH'
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('south').to('east')
    end
    
    it 'should change its facing direction from east to north when turning left' do
      place = 'PLACE 1,2,EAST'
      expect { robot.execute("#{place} LEFT") }.to change { robot.facing }.from('east').to('north')
    end
    
    # Right Turn
    it 'should change its facing direction from north to east when turning right' do
      place = 'PLACE 1,2,NORTH'
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('north').to('east')
    end
    
    it 'should change its facing direction from east to south when turning right' do
      place = 'PLACE 1,2,EAST'
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('east').to('south')
    end
    
    it 'should change its facing direction from south to west when turning right' do
      place = 'PLACE 1,2,SOUTH'
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('south').to('west')
    end
    
    it 'should change its facing direction from west to north when turning right' do
      place = 'PLACE 1,2,WEST'
      expect { robot.execute("#{place} RIGHT") }.to change { robot.facing }.from('west').to('north')
    end
    
    # Move
    context "when a 'move' command is issued" do
      it 'should move north when facing north' do
        place = 'PLACE 1,2,NORTH'
        expect { robot.execute("#{place} MOVE") }.to change { robot.coordinates.y }.by(1)
      end
      
      it 'should move east when facing east' do
        place = 'PLACE 1,2,EAST'
        expect { robot.execute("#{place} MOVE") }.to change { robot.coordinates.x }.by(1)
      end
      
      it 'should move south when facing south' do
        place = 'PLACE 1,2,SOUTH'
        expect { robot.execute("#{place} MOVE") }.to change { robot.coordinates.y }.by(-1)
      end
      
      it 'should move west when facing west' do
        place = 'PLACE 1,2,WEST'
        expect { robot.execute("#{place} MOVE") }.to change { robot.coordinates.x }.by(-1)
      end
      
      context 'when the robot is on the edge of the grid' do
        it 'should not be able to move north when its at the northern most point in the grid' do
          place = 'PLACE 2,5,NORTH'
          expect { robot.execute("#{place} MOVE") }.to_not change { robot.coordinates.y }
        end
        
        it 'should not be able to move east when its at the eastern most point in the grid' do
          place = 'PLACE 5,3,EAST'
          expect { robot.execute("#{place} MOVE") }.to_not change { robot.coordinates.x }
        end
        
        it 'should not be able to move south when its at the southern most point in the grid' do
          place = 'PLACE 3,0,SOUTH'
          expect { robot.execute("#{place} MOVE") }.to_not change { robot.coordinates.y }
        end
        
        it 'should not be able to move west when its at the western most point in the grid' do
          place = 'PLACE 3,0,WEST'
          expect { robot.execute("#{place} MOVE") }.to_not change { robot.coordinates.x }
        end
      end
    end
  end
end
