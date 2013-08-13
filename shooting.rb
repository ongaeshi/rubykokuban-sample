def setup
  Param = Parameters.new

  set_window_size(Param.window_width, Param.window_height)
  set_background(200, 200, 200)
  Console.init(Param.console_x, Param.console_y, Param.console_width, Param.console_height) if Param.debug_console

  @game_master = GameMaster.new
end

def update
  @game_master.update
end

def draw
  @game_master.draw
  
  set_color(0, 0, 0)
  text(DebugInfo.fps, 10, 15)
  text(DebugInfo.window, 10, 30)
  text(DebugInfo.mouse, 10, 45)
end

# ----------------------------------------------------------
class Pos < Struct.new(:x, :y)
  def clone
    Pos.new(self.x, self.y)
  end
  
  def limit(x_min, y_min, x_max, y_max)
    self.x = x_min if self.x < x_min
    self.x = x_max if self.x > x_max
    self.y = y_min if self.y < y_min
    self.y = y_max if self.y > y_max
  end
end

class GameMaster
  def initialize
    @fighter = Fighter.new(self, Pos.new(320, 240))
    @bullets = Bullets.new
    @enemys  = Enemys.new
  end

  def update
    @fighter.update
    @bullets.update
    @enemys.update
  end

  def draw
    @bullets.draw
    @fighter.draw
    @enemys.draw
  end

  def add_bullet(pos)
    @bullets.add(pos)
  end
end

class Fighter
  def initialize(game_master, pos)
    @game_master = game_master
    @pos = pos
  end

  def update
    # move
    @pos.x += (Input.mouse_x - @pos.x) * 0.2
    @pos.y += (Input.mouse_y - @pos.y) * 0.2
    @pos.limit(0, 0, Param.game_width, Param.game_height)

    # shot
    if Input.mouse_press?(0)
      @game_master.add_bullet(@pos)
      # Console.p @pos
    end
  end

  def draw
    # Fighter#draw
    set_fill

    set_color(220, 73, 0)
    triangle(@pos.x - 7, @pos.y, @pos.x + 7, @pos.y, @pos.x, @pos.y - 30)

    set_color(87, 25, 122)
    triangle(@pos.x - 14, @pos.y + 7, @pos.x - 2, @pos.y + 7, @pos.x - 7, @pos.y - 7)

    set_color(87, 25, 122)
    triangle(@pos.x + 14, @pos.y + 7, @pos.x + 2, @pos.y + 7, @pos.x + 7, @pos.y - 7)
  end
end

class Bullets
  def initialize
    @array = []
  end
  
  def add(pos)
    @array << Bullet.new(pos) 
  end

  def update
    @array.each {|v| v.update }

    # Remove dead bullet (Couldn't use Array#delete_if)
    @array = @array.find_all {|v| !v.dead? }
  end

  def draw
    @array.each {|v| v.draw }
  end
end

class Bullet
  def initialize(pos)
    @pos = pos.clone
    @lifetime = Param.bullet_lifetime
  end

  def update
    @pos.y -= Param.bullet_speed
    @lifetime -= 1 if @lifetime > 0
  end

  def draw
    set_fill
    set_color(51, 106, 21)
    circle(@pos.x, @pos.y, 5)
  end

  def dead?
    @lifetime == 0
  end
end

class Enemys
  def initialize
    @array = []
    @interval = Param.enemy_add_interval
  end

  def update
    @interval -= 1

    # Add random
    if @interval == 0
      0.step(rand(Param.enemy_add_max)) { add_enemy }
      @interval = Param.enemy_add_interval
    end

    # Update
    @array.each {|v| v.update }

    # Check dead
    @array = @array.find_all {|v| !v.dead? }
  end

  def draw
    @array.each {|v| v.draw }
  end

  def add_enemy
    init_pos = Param.enemy_add_pos
    speed    = rand(10 - 1) + 1

    Console.p [init_pos, speed]
    @array << Enemy.new(init_pos, speed)
  end
end

class Enemy
  def initialize(pos, speed)
    @pos = pos.clone
    @speed = speed
  end

  def update
    @pos.y += @speed
  end

  def draw
    set_fill
    set_color(196, 0, 230)
    rect(@pos.x, @pos.y, 30, 30)
  end

  def dead?
    false
  end
end

class Parameters
  attr_reader :debug_console
  attr_reader :game_width
  attr_reader :game_height
  attr_reader :console_height

  attr_reader :bullet_speed
  attr_reader :bullet_lifetime
  
  attr_reader :enemy_add_max
  attr_reader :enemy_add_interval

  def initialize
    # basic
    @debug_console  = true                     # Display console window?
    @game_width     = 640
    @game_height    = 480
    @console_height = @debug_console ? 200 : 0

    # bullet
    @bullet_speed    = 7
    @bullet_lifetime = 120

    # enemy
    @enemy_add_max      = 5
    @enemy_add_interval = 180
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

  def enemy_add_pos
    Pos.new(rand(600 - 10) + 10, 0)
  end
end


