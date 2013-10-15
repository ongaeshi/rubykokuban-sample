def update
  @scale ||= 0.0
  @scale += 0.05
  @scale = 0.0 if @scale > 3.0
end

def draw
  @image ||= Image.load("sample.png")
  set_color(Color::White)
  @image.draw(0, 0, @image.width * @scale, @image.height * @scale)
end




