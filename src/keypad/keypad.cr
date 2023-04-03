require "./hal"

# Hold and hold durration ?
# Flag for each key, state changed (that can be acknowledged ?)
module Keypad
  extend self
  
  FRAMES_TO_HOLD = 60
  enum State
    None = 0
    Pressed = 1
    #Held = 2
    Released = 3
  end

  @@a = State::None
  @@b = State::None
  @@l = State::None
  @@r = State::None
  @@start = State::None
  @@option = State::None
  @@up = State::None
  @@down = State::None
  @@left = State::None
  @@right = State::None

  def a
    @@a
  end

  def process_input(i, state)
    case {(~HAL.keyinput & (1 << i)) != 0, state}
    in {true, State::None} then State::Pressed
    in {false, State::None} then State::None

    in {true, State::Pressed} then State::Pressed
    in {false, State::Pressed} then State::Released

    in {true, State::Released} then State::Pressed
    in {false, State::Released} then State::None
    end
  end
  
  def process_inputs
    @@a = process_input 0, @@a
    @@b = process_input 1, @@b
    @@l = process_input 2, @@l
    @@r = process_input 3, @@r
    @@option = process_input 4, @@option
    @@start = process_input 5, @@start
    @@up = process_input 6, @@up
    @@left = process_input 7, @@left
    @@right = process_input 8, @@right
    @@down = process_input 9, @@down
  end
end
