class Coordinates
  attr_accessor :x, :y
  
  X_RANGE = 0..5
  Y_RANGE = 0..5
  
  def initialize(x, y)
    self.x = x
    self.y = y
  end
  
  def move(facing)
    send("move_#{facing}")
  end

  def is_valid?
    self.x.is_a(Integer) && X_RANGE.include?(self.x) &&
    self.y.is_a(Integer) && Y_RANGE.include?(self.y)
  end
  
  private
  def move_north
    self.y < Y_RANGE.max && self.y += 1
  end
  
  def move_east
    self.x < X_RANGE.max && self.x += 1
  end
  
  def move_south
    self.y > Y_RANGE.min && self.y -= 1
  end
  
  def move_west
    self.x > X_RANGE.min && self.x -= 1
  end
end
