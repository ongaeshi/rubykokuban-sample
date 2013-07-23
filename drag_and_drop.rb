def setup
  set_window_size(640, 768)
  # set_window_pos(0, 0)

  @shapes = []
  @shapes << Triangle.new(Pos.new(180, 370))
  @shapes << Circle.new(Pos.new(320, 200))
  @shapes << RectRounded.new(Pos.new(460, 370))
  @shapes << Rect.new(Pos.new(320, 540))

  set_background(255, 255, 255)
  
  # Console.init(20, 560)
end

def update
  @shapes.each do |s|
    s.update
    break if s.dragged
  end
end

def draw
  @shapes.reverse.each {|s| s.draw}

  # Console.draw

  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
end

# ----------------------------------------------------------

class Pos < Struct.new(:x, :y)
  def lengh_square(ax, ay)
    (x - ax)**2 + (y - ay)**2
  end
end

module IDraggable
  attr_reader :dragged

  def initialize(pos)
    @pos = pos
    @dragged = false
  end

  def update
    if !@dragged
      if Input.mouse_press?(0)
        @dragged = true if (@pos.lengh_square(Input.mouse_x, Input.mouse_y) < 50**2)
        @offset = Pos.new(@pos.x - Input.mouse_x, @pos.y - Input.mouse_y)
      end
    else
      # Console.p(@pos)

      if !Input.mouse_down?(0)
        @dragged = false
      else
        @pos.x = Input.mouse_x + @offset.x
        @pos.y = Input.mouse_y + @offset.y
      end
    end
  end
end

class Circle
  include IDraggable
  
  def draw
    set_fill
    set_color(87, 25, 122)
    circle(@pos.x, @pos.y, 50)
  end
end

class Triangle
  include IDraggable

  def draw
    set_fill
    set_color(220, 73, 0)
    triangle(@pos.x, @pos.y - 43, @pos.x - 50, @pos.y + 43, @pos.x + 50, @pos.y + 43)
  end
end

class Rect
  include IDraggable

  def draw
    set_fill
    set_color(51, 106, 21)
    rect(@pos.x - 50, @pos.y - 50, 100, 100)
  end
end

class RectRounded
  include IDraggable

  def draw
    set_fill
    set_line_width(1)
    set_color(196, 0, 230)
    rect_rounded(@pos.x - 50, @pos.y - 50, 100, 100, 30)
  end
end





