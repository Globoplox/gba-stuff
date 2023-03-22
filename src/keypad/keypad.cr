require "./hal"

# Hold and hold durration ?
# Flag for each key, state changed (that can be acknowledged ?)
module Keypad
  FRAMES_TO_HOLD = 60
  enum State
    None = 0
    Pressed = 1
    #Held = 2
    Released = 3
  end

  @a = State::None
  @b = State::None
  @l = State::None
  @r = State::None
  @start = State::None
  @select = State::None
  @up = State::None
  @down = State::None
  @left = State::None
  @right = State::None

  def process_input(i, state)
    case {(~HAL.keyinput & (1 << i)) == true, state}
    when {true, :none} then State::Pressed
    when {false, :none} then State::None

    when {true, :pressed} then State::Pressed
    when {false, :pressed} then State::Released

    when {true, :released} then State::Pressed
    when {false, :released} then State::None
    end
  end
  
  def process_inputs
    @a = process_input i, @a
    @b = process_input i, @b
    @l = process_input i, @l
    @r = process_input i, @r
    @select = process_input i, @select
    @start = process_input i, @start
    @up = process_input i, @up
    @left = process_input i, @left
    @right = process_input i, @right
    @bottom = process_input i, @bottom
  end
end
