$debug_console = true

def setup
  @debug_console = true
  @param = Param.new
  set_window_size(@param.window_width, @param.window_height)
  set_background(200, 200, 200)
  Console.init(@param.console_x, @param.console_y, @param.console_width, @param.console_height) if $debug_console

  @fighter = Fighter.new(Pos.new(320, 240))
end

def update
  @fighter.update
end

def draw
  @fighter.draw

  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
end

# ----------------------------------------------------------
class Pos < Struct.new(:x, :y)
  def limit(x_min, y_min, x_max, y_max)
    self.x = x_min if self.x < x_min
    self.x = x_max if self.x > x_max
    self.y = y_min if self.y < y_min
    self.y = y_max if self.y > y_max
  end
end

class Fighter
  def initialize(pos)
    @pos = pos
  end

  def update
    @pos.x += (Input.mouse_x - @pos.x) * 0.2
    @pos.y += (Input.mouse_y - @pos.y) * 0.2
    @pos.limit(0, 0, 640, 480)
  end

  def draw
    set_fill
    set_color(87, 25, 122)
    circle(@pos.x, @pos.y, 30)
  end
end

class Param
  attr_reader :game_width
  attr_reader :game_height
  attr_reader :console_height

  def initialize
    @game_width     = 640
    @game_height    = 480
    @console_height = $debug_console ? 200 : 0
  end

  def console_x
    0
  end

  def console_y
    game_height
  end

  def console_width
    game_width
  end

  def window_width
    game_width
  end

  def window_height
    game_height + console_height
  end
end


