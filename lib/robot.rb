class Robot
  attr_accessor :coordinate, :facing, :currently_placing, :successfully_placed
  
  COMMANDS = [:place, :move, :left, :right, :report]
  
  def initialize
    self.currently_placing = false
    self.successfully_placed = false
  end
  
  def execute(commands)
    commands.each do |cmd|
      if self.currently_placing
        cmd = cmd.split(',')
        place(x: cmd[0].to_i, y: cmd[1].to_i, facing: cmd[2].to_sym)
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
      self.coordinate = Coordinate.new(x, y)
      self.facing = Facing.new(facing)
      self.successfully_placed = true
    end
  end
  
  private
  def valid_command?(cmd)
    COMMANDS.include?(cmd.to_sym)
  end
  
  def valid_place_command?(x, y, facing)
    Coordinate.new(x,y).is_valid? &&
    Facing.new(facing).is_valid?
  end
end
