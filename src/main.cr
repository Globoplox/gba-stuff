lib HAL
$palette = PALETTE : UInt16[512]
end

abstract struct ARoot
  abstract def do_it
end

struct Implem1 < ARoot
  def do_it
    pointerof(Screen::HAL.palette).as(UInt16*)[0x1] = 0xff00u16
  end
end

struct Implem2 < ARoot
  def do_it
    pointerof(Screen::HAL.palette).as(UInt16*)[0x2] = 0x00ffu16
  end
end


fun gba_main : NoReturn

  while true
  end
end

gba_main
