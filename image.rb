def setup
  set_window_size(640, 480)
  # set_window_pos(0, 0)
  set_background(255, 255, 255)

  color = Color.new(1, 2, 3)
  p color.r, color.g, color.b, color.a

  @image  = Image.load("sample.png")
  @image2 = Image.load("sample.png")
end

def update
  @image.rotate90 if Input.mouse_press?(0)
  @image2.rotate90(-1) if Input.mouse_down?(2)
  @screen_image = Image.grab_screen(50, 90, 80, 80)

  # if Input.mouse_press?(2)
  #   Image.grab_screen(0, 0, window_width, window_height).save("screenshot.png")
  # end
end

def draw
  # Draw image
  x = 10; y = 100
  description("draw(x, y)", x, y)
  set_color(255, 255, 255)
  @image.draw(x, y)

  x = 110; y = 100
  description("blend color", x, y)
  set_color(128, 255, 128)
  @image2.draw(x, y)

  x = 210; y = 100
  description("draw(x,y,w,h)", x, y)
  set_color(255, 255, 255)
  @image.draw(x, y, 80, 80)

  x = 330; y = 100
  description("draw_sub", x, y)
  set_color(255, 255, 255)
  @image.draw_sub(x + 32, y,      32, 32,  0,  0)
  @image.draw_sub(x + 32, y + 32, 32, 32, 32,  0)
  @image.draw_sub(x,      y + 32, 32, 32,  0, 32)
  @image.draw_sub(x,      y,      32, 32, 32, 32)

  x = 430; y = 100
  description("draw_sub2", x, y)
  set_color(255, 255, 255)
  @image.draw_sub(x + 32, y,      32, 32,  0,  0, 12, 12)
  @image.draw_sub(x + 32, y + 32, 32, 32, 32,  0, 12, 12)
  @image.draw_sub(x,      y + 32, 32, 32,  0, 32, 12, 12)
  @image.draw_sub(x,      y,      32, 32, 32, 32, 12, 12)

  x = 210; y = 200
  description("resize", x, y)
  set_color(255, 255, 255)
  @resize_image = @image.clone.resize(40, 40) unless @resize_image
  @resize_image.draw(x, y)

  x = 310; y = 200
  description "crop!", x, y
  set_color(255, 255, 255)
  @crop_bang_image = @image.clone.crop!(10, 10, 30, 30) unless @crop_bang_image
  @crop_bang_image.draw(x, y)

  x = 410; y = 200
  description "crop", x, y
  set_color(255, 255, 255)
  @crop_image = @image.crop(10, 10, 30, 30) unless @crop_image
  @crop_image.draw(x, y)

  x = 510; y = 200
  description("rotate90", x, y)
  set_color(255, 255, 255)
  @rotate_image = @image.clone.rotate90 unless @rotate_image
  @rotate_image.draw(x, y)

  x = 10; y = 200
  description("mirror", x, y)
  set_color(255, 255, 255)
  @mirror_image = @image.clone.mirror(false, true) unless @mirror_image
  @mirror_image.draw(x, y)

  x = 110; y = 200
  description("clone", x, y)
  set_color(255, 255, 255)
  @clone_image = @mirror_image.clone.resize(80, 64) unless @clone_image
  @clone_image.draw(x, y)

  x = 10; y = 300
  description("grab_screen", x, y)
  set_color(255, 255, 255)
  @screen_image.draw(x, y + 10)

  x = 110; y = 300
  description("set_color", x, y)
  set_color(255, 255, 255)
  unless @set_color_image
    @set_color_image = @image.clone

    # p @set_color_image.color(32, 32).r
    # p @set_color_image.color(0, 0).r
    # p @set_color_image.color(32, 10).r

    (0..63).each do |y|
      @set_color_image.set_color(32, y, Color.new(255, 0, 0))
    end

    @set_color_image.update
  end

  @set_color_image.draw(x, y)

  # debug info
  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text("width: #{@image.width}, height: #{@image.height}", 10, 50)
end

# ----------------------------------------------------------

def description(text, x, y)
  set_color(0, 0, 0)
  text(text, x, y)
end

