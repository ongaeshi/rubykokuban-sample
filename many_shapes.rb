ADD_SPEED     = 5
CIRCLE_RADIUS = 50
Y_OFFSET      = 80

def setup
  set_window_size(800, 600)
  @shapes = []
end

def update
  if Input.mouse_down?(0)
    (1..ADD_SPEED).each do
      offset = Y_OFFSET + CIRCLE_RADIUS
      @shapes << Circle.new(Pos.new(rand(window_width), rand(window_height - offset) + offset), MyColor.rand)
    end
  end

  if Input.mouse_down?(2)
    (1..ADD_SPEED).each do
      @shapes.pop
    end
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

class MyColor < Struct.new(:r, :g, :b)
  def self.rand
    MyColor.new(Kernel.rand(255), Kernel.rand(255), Kernel.rand(255))
  end
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
    circle(@pos.x, @pos.y, CIRCLE_RADIUS)
  end
end
