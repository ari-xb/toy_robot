class Robot
  attr_accessor :coordinates, :facing, :currently_placing, :successfully_placed
  
  COMMANDS = [:place, :move, :left, :right, :report]

  def initialize
    self.currently_placing = false
    self.successfully_placed = false
  end
  
  def execute(commands)
    commands.each do |cmd|
      if self.currently_placing
        cmd = cmd.split(',')
        place(x: cmd[0], y: cmd[1], facing: cmd[2].to_sym)
        self.currently_placing = false
      elsif cmd.to_sym == :place
        self.currently_placing = true
        next
      elsif self.successfully_placed && valid_command?(cmd)
        send(cmd.to_sym)
      end
    end
  end
  
  def place(x:, y:, facing:)
    if valid_place_command?(x, y, facing)
      self.coordinates = Coordinates.new(x.to_i, y.to_i)
      self.facing = Facing.new(facing)
      self.successfully_placed = true
    end
  end
  
  def move
    self.coordinates.move(self.facing.direction)
  end
  
  def left
    self.facing.left_turn
  end
  
  def right
    self.facing.right_turn
  end
  
  def report
    puts self
  end
  
  private
  def to_s
    "Output: #{self.coordinates},#{self.facing}\n"
  end
  
  def valid_command?(cmd)
    COMMANDS.include?(cmd.to_sym)
  end
  
  def valid_place_command?(x, y, facing)
    Coordinates.new(x,y).is_valid? &&
    Facing.new(facing).is_valid?
  end
end
