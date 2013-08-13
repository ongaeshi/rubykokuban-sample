$debug_console = true

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

def setup
  @debug_console = true
  @param = Param.new
  set_window_size(@param.window_width, @param.window_height)
  set_background(200, 200, 200)
  @frame_counter = 0
  Console.init(@param.console_x, @param.console_y, @param.console_width, @param.console_height) if $debug_console
end

def update
  @frame_counter += 1
  p @frame_counter / 60 if @frame_counter % 60 == 0

  p "click: (#{Input.mouse_x}, #{Input.mouse_y})" if Input.mouse_press?(0)

  Console.clear if Input.mouse_down?(2)
end

def draw
  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
end

