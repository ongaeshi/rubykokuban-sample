def setup
  puts "Hello mruby"
  p "Hello mruby"

  @x = 400
  @speed = 10
end

def update
  @speed += 5 if Input.mouse_press?(0)
  @speed -= 5 if Input.mouse_down?(2) 

  @x += @speed

  if @x > 1024
    @x = 0
  elsif @x < 0
    @x = 1024 
  end
end

def draw
  set_color(255, 0, 0)
  circle(@x, 100, 30)

  set_color(0, 255, 0)
  circle(@x + 20, 200, 35)

  set_color(0, 0, 255)
  circle(@x + 40, 300, 40)

  c = (@x * 0.7) % 255
  set_color(c, c, c)
  circle(@x + 60, 400, 45)

  set_color(0, 128, 128)
  circle(Input.mouse_x, Input.mouse_y, 30)

  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
  text(<<EOF, 10, 60)
speed       : #{@speed}
mouse left  : speed up
mouse right : speed down
EOF
end

