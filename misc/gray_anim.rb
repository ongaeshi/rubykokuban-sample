def setup
  set_window_size(520, 420)
  set_background(Color::Linen)
  @image = Image.load("red-flower.jpg")
  @rate = 0.0
  @frame = 0
  @image_gray = gray(@image, @rate)
end

def update
  @frame += 1
  @rate += 0.003
  @rate -= 1.0 if @rate > 1.0
  @image_gray = gray(@image, @rate) if @frame % 10 == 0

  # @sequence_shot = SequenceShot.new(10, 40) unless @sequence_shot
  # @sequence_shot.update
end

def draw
  # Draw image
  x = 10; y = 30
  set_color(Color::White)
  @image_gray.draw(x, y, @image_gray.width * 2.5, @image_gray.height * 2.5)

  # debug info
  set_color(0, 0, 0)
  # text(DebugInfo.fps, 10, 15)
  text("gray rate: #{@rate}", 10, 15)
end

# ----------------------------------------------------------
def gray(image, rate)
  image.map_pixels do |x, y|
    c = image.color(x, y)
    b = c.brightness
    Color.new(c.r * (1.0 - rate) + b * rate,
              c.g * (1.0 - rate) + b * rate,
              c.b * (1.0 - rate) + b * rate,
              c.a)
  end
end

def description(text, x, y)
  set_color(0, 0, 0)
  text(text, x, y)
end




