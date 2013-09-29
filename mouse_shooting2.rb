def setup
  Param = Parameters.new

  set_window_size(Param.window_width, Param.window_height)
  set_background(200, 200, 200)
  Console.init(Param.console_x, Param.console_y, Param.console_width, Param.console_height) if Param.debug_console

  $image = Image.load("mouse_shooting_tile.png")
  @game_master = GameMaster.new
  @bg = Image.load("mouse_shooting_bg.jpg")
end

def update
  @game_master.update
end

def draw
  @bg.draw(0, 0)
  @game_master.draw
  
  set_color(Color::White)
  text(DebugInfo.fps, 10, 15)
  # text(DebugInfo.window, 10, 30)
  # text(DebugInfo.mouse, 10, 45)
end

# ----------------------------------------------------------
class GameMaster
  attr_reader :enemys
  attr_reader :image
  
  def initialize
    @fighter  = Fighter.new(self, Vec2.new(320, 240))
    @bullets  = Bullets.new
    @enemys   = Enemys.new(self)
    @interval = Param.enemy_add_interval(0)
    @turn     = 0
    @score    = 0
    @next_dir = @prev_dir = rand(4)
  end

  def update
    if !@fighter.is_dead
      @interval -= 1

      @fighter.update
      @bullets.update

      if @interval == 0
        @turn += 1
        @interval = Param.enemy_add_interval(level)
        @enemys.add_group(@next_dir)
        @prev_dir = @next_dir
        @next_dir = rand(4)
      end

      @enemys.update
      @enemys.check_dead(@bullets)

      @fighter.check_dead
    end
  end

  def draw
    draw_notce_line(@prev_dir,   0,   0, 139)
    draw_notce_line(@next_dir, 255, 241,  54)
    
    @bullets.draw
    @fighter.draw
    @enemys.draw

    set_color(Color::White)
    text("Level: #{level + 1}", 10, 30)
    text("Score: #{@score}", 10, 45)

    if @fighter.is_dead
      set_color(Color::White)
      text("GameOver", 280, 240)
    elsif @turn % Param.levelup_interval == 0
      set_color(Color::White)
      text("Level #{level + 1}", 280, 240)
    end
  end

  def add_bullet(pos)
    @bullets.add(pos)
  end

  def inc_score(value)
    @score += value
  end

  def level
    (@turn / Param.levelup_interval).to_i
  end

  def draw_notce_line(dir, r, g, b)
    set_color(r, g, b)
    
    case dir
    when 0
      line(10, 10, 630, 10)
    when 1
      line(630, 10, 630, 470)
    when 2
      line(10, 470, 630, 470)
    when 3
      line(10, 10, 10, 470)
    end
  end
end

class Fighter
  attr_reader :is_dead

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
    end
  end

  def check_dead
    @game_master.enemys.array.each do |enemy|
      if @pos.length_square(enemy.pos) < 20**2
        @is_dead = true
        break
      end
    end
  end

  def draw
    set_color(Color::White)
    $image.draw_sub(@pos.x - 15, @pos.y - 30, 30, 30, 30, 0)
  end
end

class Bullets
  attr_reader :array

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
  attr_reader :pos
  
  def initialize(pos)
    @pos = pos.clone
    @lifetime = Param.bullet_lifetime
    @is_hit = false
  end

  def update
    @pos.y -= Param.bullet_speed
    @lifetime -= 1 if @lifetime > 0
  end

  def draw
    set_color(Color::White)
    $image.draw_sub(@pos.x - 5, @pos.y - 5, 10, 10, 60, 0)
  end

  def dead?
    @lifetime == 0 || @is_hit
  end

  def set_hit
    @is_hit = true
  end
end

class Enemys
  attr_reader :array

  def initialize(game_master)
    @game_master = game_master
    @array = []
  end

  def add_group(dir)
    0.step(Param.enemy_add_num(@game_master.level)) { add_enemy(dir) }
    is_spawn = true
  end

  def update
    @array.each {|v| v.update }
  end

  def check_dead(bullets)
    @array.each do |enemy|
      bullets.array.each do |bullet|
        break if enemy.check_dead(@game_master, bullet)
      end
    end

    # Check dead
    @array = @array.find_all {|v| !v.dead? }
  end

  def draw
    @array.each {|v| v.draw }
  end

  def add_enemy(dir)
    case dir
    when 0
      init_pos    = Vec2.new(rand(Param.game_width), 0)
      init_speed  = Vec2.new(0, Param.enemy_base_speed(@game_master.level))
    when 1
      init_pos    = Vec2.new(Param.game_width, rand(Param.game_height))
      init_speed  = Vec2.new(-Param.enemy_base_speed(@game_master.level), 0)
    when 2
      init_pos    = Vec2.new(rand(Param.game_width), Param.game_height)
      init_speed  = Vec2.new(0, -Param.enemy_base_speed(@game_master.level))
    when 3
      init_pos    = Vec2.new(0, rand(Param.game_height))
      init_speed  = Vec2.new(Param.enemy_base_speed(@game_master.level), 0)
    end

    # Console.p [init_pos, init_speed]
    @array << Enemy.new(init_pos, init_speed)
  end
end

class Enemy
  attr_reader :pos

  def initialize(pos, speed)
    @pos     = pos.clone
    @speed   = speed.clone
    @is_dead = false
    @life    = 1
  end

  def update
    @pos += @speed
  end

  def check_dead(game_master, bullet)
    if bullet.pos.length_square(@pos) < 30**2
      @life -= 1
      if @life == 0
        @is_dead = true
        game_master.inc_score(1)
      end
      bullet.set_hit
      true
    else
      false
    end
  end

  def draw
    set_color(Color::White)
    $image.draw_sub(@pos.x - 15, @pos.y - 15, 30, 30, 0, 0)
  end

  def dead?
    @is_dead
  end
end

class Vec2 < Struct.new(:x, :y)
  def clone
    Vec2.new(self.x, self.y)
  end
  
  def limit(x_min, y_min, x_max, y_max)
    self.x = x_min if self.x < x_min
    self.x = x_max if self.x > x_max
    self.y = y_min if self.y < y_min
    self.y = y_max if self.y > y_max
  end

  def length_square(rhs)
    (x - rhs.x)**2 + (y - rhs.y)**2
  end

  def +(pos)
    Vec2.new(x + pos.x, y + pos.y)
  end
end

class Parameters
  attr_reader :debug_console
  attr_reader :game_width
  attr_reader :game_height
  attr_reader :console_height

  attr_reader :levelup_interval

  attr_reader :bullet_speed
  attr_reader :bullet_lifetime
  
  attr_reader :enemy_add_max

  def initialize
    # basic
    @debug_console  = false                     # Display console window?
    @game_width     = 640
    @game_height    = 480
    @console_height = @debug_console ? 200 : 0

    # game_master
    @levelup_interval = 7

    # bullet
    @bullet_speed    = 7
    @bullet_lifetime = 120

    # level parameter
    @level_parameters =
      [
       {base_speed_min: 1,  base_speed_max:  3, add_min: 1, add_max: 3, add_interval: 240},  # level1
       {base_speed_min: 2,  base_speed_max:  6, add_min: 1, add_max: 3, add_interval: 230},   # level2
       {base_speed_min: 3,  base_speed_max:  7, add_min: 1, add_max: 5, add_interval: 220},  # level3
       {base_speed_min: 4,  base_speed_max:  8, add_min: 1, add_max: 5, add_interval: 210},  # level4
       {base_speed_min: 5,  base_speed_max:  9, add_min: 1, add_max: 6, add_interval:  20},  # level5
       {base_speed_min: 6,  base_speed_max: 11, add_min: 1, add_max: 6, add_interval: 200},  # level6
       {base_speed_min: 7,  base_speed_max: 13, add_min: 2, add_max: 7, add_interval: 190},  # level7
       {base_speed_min: 8,  base_speed_max: 15, add_min: 2, add_max: 7, add_interval: 180},  # level8
       {base_speed_min: 9,  base_speed_max: 17, add_min: 3, add_max: 8, add_interval: 170},  # level9
       {base_speed_min: 10, base_speed_max: 19, add_min: 3, add_max: 9, add_interval: 160},  # level10
      ]
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

  def level_parameter(level)
    if level < @level_parameters.size
      current = @level_parameters[level]
    else
      current = @level_parameters[-1]
    end
  end

  def enemy_base_speed(level)
    current = level_parameter(level)
    rand(current[:base_speed_max] - current[:base_speed_min]) + current[:base_speed_min]
  end

  def enemy_add_num(level)
    current = level_parameter(level)
    rand(current[:add_max] - current[:add_min]) + current[:add_min]
  end

  def enemy_add_interval(level)
    level_parameter(level)[:add_interval]
  end
end


