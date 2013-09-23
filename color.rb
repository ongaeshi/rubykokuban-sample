def setup
  set_window_size(640, 480)
  set_background(255, 255, 255)

  @hue = 0
  @rate = 0
end

def update
  @hue += 1
  @hue = 0 if @hue >= 255

  @rate += 0.01
  @rate = 0.0 if @rate >= 1.0
end

def assert(val)
  raise if !val
end

def draw
  set_fill

  x = 10; y = 50
  description("Color.new", x, y)
  c = Color.new(128, 128, 128)
  set_color(c.r, c.g, c.b)
  circle(x + 32, y + 32, 32)

  x = 110; y = 50
  description("Color.hex", x, y)
  set_color(Color.hex(0xD27EB3))
  circle(x + 32, y + 32, 32)

  x = 210; y = 50
  description("Color.hsb", x, y)
  set_color(Color.hsb(@hue, 200, 255))
  circle(x + 32, y + 32, 32)
  
  x = 310; y = 50
  description("clone", x, y)
  clone_color = c.clone
  clone_color.r = 180
  clone_color.g = 90
  clone_color.b = 180
  clone_color.a = 128
  set_color(c)
  circle(x, y + 32, 32)
  set_color(clone_color)
  circle(x + 32, y + 32, 32)

  x = 410; y = 50
  description("to_hex", x, y)
  c = Color.new(100, 255, 0)
  set_color(0, 0, 0)
  text("(#{c.r},#{c.g},#{c.b})", x, y + 25)
  text("0x#{c.to_hex.to_s(16)}", x, y + 50)

  x = 10; y = 150
  description("base", x, y)
  c = Color.hex(0x3DB680)
  set_color(c)
  circle(x + 32, y + 32, 32)

  x = 110; y = 150
  description("invert", x, y)
  set_color(c.invert)
  circle(x + 32, y + 32, 32)

  x = 210; y = 150
  description("normalize", x, y)
  set_color(c.normalize)
  circle(x + 32, y + 32, 32)

  x = 310; y = 150
  description("lerp(white, #{@rate})", x, y)
  set_color(c.lerp(Color.new(255, 255, 255), @rate))
  circle(x + 32, y + 32, 32)

  x = 10; y = 250
  description("to_hsb", x, y)
  c = Color.new(100, 255, 0)
  set_color(c)
  rect(x + 95, y + 12, 16, 16)
  set_color(0, 0, 0)
  text("(#{c.r},#{c.g},#{c.b})", x, y + 25)
  text("hue: #{c.hue}\nsaturation: #{c.saturation}\nbrightness: #{c.brightness}\nlightness: #{c.lightness}", x, y + 50)

  x = 210; y = 250
  description("op", x, y)
  c1 = Color.new( 50, 100, 150)
  c2 = Color.new(150, 100,  50)
  c3 = Color.new( 50, 100, 150)

  description("c1 == c2", x, y + 15)
  assert(c1 == c3)

  description("c1 != c2", x, y + 30)
  assert(c1 != c2)

  description("c1 + 100.0", x, y + 45)
  assert(c1 + 100 == Color.new(150, 200, 250))

  description("c1 + c2", x, y + 60)
  assert(c1 + c2 == Color.new(200, 200, 200))

  description("c1 - 10.0", x, y + 75)
  assert(c1 - 10 == Color.new( 40,  90, 140))

  description("c1 - c2", x, y + 90)
  assert(c1 - c2 == Color.new(156,   0, 100))

  description("c1 * 0.5", x, y + 105)
  assert(c1 * 0.5 == Color.new( 25,  50,  75))

  description("c1 * c2", x, y + 120)
  assert(c1 * Color.new(128, 128, 128) == Color.new( 25, 50, 75))

  description("c1 / 2.0", x, y + 135)
  assert(c1 / 2 == Color.new( 25,  50,  75))

  description("c1 / c2", x, y + 150)
  assert(c1 / Color.new(128, 128, 255) == Color.new( 99, 199, 150))

  description("c[0]\nc[0]=128", x, y + 166)
  assert(c1[0] == 50)
  assert(c1[1] == 100)
  assert(c1[2] == 150)
  assert(c1[3] == 255)

  c1[0] = 255
  assert(c1[0] == 255)

  x = 310; y = 250
  description("set, set_hex, set_hsb", x, y)
  c = Color.new(0, 0, 0)

  # set_hsb
  c.brightness = 128
  c.saturation = 255
  c.hue        = 128
  set_color(c)
  rect(x, y + 5, 80, 16)
  set_color(0, 0, 0)
  text(c.to_hsb.to_s, x, y + 40)
  
  c.set_hsb(128, 255, 255)
  set_color(c)
  rect(x, y + 50, 80, 16)
  set_color(0, 0, 0)
  text(c.to_hsb.to_s, x, y + 85)

  c.set_hsb(0, 255, 255)
  set_color(c)
  rect(x, y + 95, 80, 16)
  set_color(0, 0, 0)
  text(c.to_hsb.to_s, x, y + 130)

  # set_hex
  c.set_hex(0xF0BA32)
  set_color(c)
  rect(x, y + 140, 80, 16)

  # set
  c.set(Color.new(0, 255, 0))
  set_color(c)
  rect(x, y + 160, 80, 16)

  c.set(255, 0, 0)
  set_color(c)
  rect(x, y + 180, 80, 16)
  
  c.set(255, 0, 0, 128)
  set_color(c)
  rect(x, y + 200, 80, 16)

  # debug info
  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)

end

# ----------------------------------------------------------

def description(text, x, y)
  set_color(0, 0, 0)
  text(text, x, y)
end

