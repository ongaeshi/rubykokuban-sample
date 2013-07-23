def setup
  @lines = []
  @backgrounds = []
end

def update
  if Input.mouse_down?(0)
    @lines << Circle.new(Input.mouse_x, Input.mouse_y, 15, Color.new(0, 0, 0))
  end

  if Input.mouse_down?(2)
    @backgrounds << Circle.new(Input.mouse_x, Input.mouse_y, 30, Color.new(255, 255, 255))
  end
end

def draw
  @backgrounds.each do |c|
    c.draw
  end

  @lines.each do |c|
    c.draw
  end

  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
end

# ----------------------------------------------------------

class Circle
  attr_reader :x
  attr_reader :y
  attr_reader :radius

  def initialize(x, y, radius, color)
    @x = x
    @y = y
    @radius = radius
    @color = color
  end

  def draw
    # set_color(255, 0, 0)
    @color.set_color
    circle(@x, @y, @radius)
  end
end

class Color
  def initialize(r, g, b)
    @r = r
    @g = g
    @b = b
  end

  def set_color
    Kernel.set_color(@r, @g, @b)
  end
end


