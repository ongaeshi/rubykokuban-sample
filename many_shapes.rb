def setup
  set_window_size(580, 600)
  @shapes = []
end

def update
  if Input.mouse_press?(0)
    @shapes << Circle.new(Pos.new(200, 200), Color.new(87, 25, 122))
  end
  
  @shapes.each do |s|
    s.update
  end
end

def draw
  set_background(255, 255, 255)

  @shapes.each do |s|
    s.draw
  end

  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
  text("shapes: #{@shapes.size}", 10, 60)
end

# ----------------------------------------------------------

class Pos < Struct.new(:x, :y)
end

class Color < Struct.new(:r, :g, :b)
end

class Circle
  def initialize(pos, color)
    @pos = pos
    @color = color
  end

  def update
  end

  def draw
    set_fill
    set_color(@color.r, @color.g, @color.b)
    circle(@pos.x, @pos.y, 50)
  end
end
