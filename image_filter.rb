def setup
  set_window_size(640, 480)
  set_background(Color::Linen.r, Color::Linen.g, Color::Linen.b)

  @image = Image.load("fuji.jpg")
  @image_binarized = binarization(@image)
  @image_gray = gray(@image)

  # @image_gray.save("fuji-gray.jpg")
end

def draw
  # Draw image
  x = 10; y = 50
  description("original", x, y - 5)
  set_color(Color::White)
  @image.draw(x, y)

  x = 310; y = 50
  description("binarization", x, y - 5)
  set_color(Color::White)
  @image_binarized.draw(x, y)

  x = 10; y = 270
  description("gray", x, y - 5)
  set_color(Color::White)
  @image_gray.draw(x, y)

  x = 310; y = 270
  description("mosaic", x, y - 5)
  draw_mosaic(@image, x, y, 16, 16)

  # debug info
  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
end

# ----------------------------------------------------------

def binarization(image)
  image.map_pixels do |x, y|
    image.color(x, y).lightness > 200 ? Color::White : Color::Black
  end
end

def gray(image)
  image.map_pixels do |x, y|
    c = image.color(x, y)
    b = c.brightness
    Color.new(b, b, b, c.a)
  end
end

def draw_mosaic(image, x, y, width, height)
  image.each_pixels(width, height) do |i, j|
    set_color(image.color(i, j))
    rect(x + i, y + j, width, height)
  end
end

def description(text, x, y)
  set_color(0, 0, 0)
  text(text, x, y)
end



