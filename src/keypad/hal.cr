module Keypad
  lib HAL
    KEY_A = 1
    KEY_B = {{1 << 1}}
    KEY_SELECT = {{1 << 2}}
    KEY_START = {{1 << 3}}
    KEY_RIGHT = {{1 << 4}}
    KEY_LEFT = {{1 << 5}}
    KEY_UP = {{1 << 6}}
    KEY_DOWN = {{1 << 7}}
    KEY_L = {{1 << 8}}
    KEY_R = {{1 << 9}}
    KEY_MAX = 10

    # Resgiter I/O for keypad input control.
    # Note the bit are set by default, and clear during input.
    $keyinput = KEYINPUT : UInt16
    
    KEYCNT_ENABLE_IRQ = {{1 << 0xE}}
    # If set, all enabled keys must be down to trigger irq. If clear, any enabled key down trigger the irq. 
    KEYCNT_MODE = {{1 << 0xF}}

    # Resgiter I/O for keypad interrupt control.
    $keycnt = KEYCNT : UInt16
  end
end
