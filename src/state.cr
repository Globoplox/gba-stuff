module State
  @@current : State
  @@draw_init = false

  def self.call
    @@current.call
  end

  def self.draw
    unless @@draw_init
      @@current.draw_init
      @@draw_init = true
    end
    @@current.draw
  end

  abstract def call

  def draw
  end

  def init_draw
  end
end

require "./game/splash"
  
module State
  @@current = Splash
end

