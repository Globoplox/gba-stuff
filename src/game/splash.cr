require "../state"

module Splash
  extend self
  include State
  @@i = 0

  def draw_init
    GBA::Screen::Mode3.init
  end

  def call
    @@i = @@i &+ 1 if @@i < {{240 * 140}}
  end

  def draw
    GBA::Screen::Mode3[@@i] = 0x0ff0u16
  end
end
