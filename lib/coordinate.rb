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
    self.x.to_s.match(/[0-9]/) && X_RANGE.include?(self.x.to_i) &&
    self.y.to_s.match(/[0-9]/) && Y_RANGE.include?(self.y.to_i)
  end
  
  private
  def to_s
    "#{self.x},#{self.y}"
  end
  
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
