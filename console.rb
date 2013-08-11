def setup
  set_window_size(480, 380)
  set_background(200, 200, 200)
  @frame_counter = 0
  Console.init(12, 60, 456, 300)
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

