class Facing
  attr_accessor :direction
  
  FACING = [:north, :east, :south, :west]
  
  def initialize(facing)
    self.direction = facing
  end
  
  def left_turn
    turn(-1)
  end
  
  def right_turn
    turn(1)
  end
  
  def is_valid?
    FACING.include?(self.direction)
  end
  
  private
  def turn(direction)
    facing_index = FACING.index(self.direction)
    self.direction = FACING.rotate(direction)[facing_index]
  end
end
