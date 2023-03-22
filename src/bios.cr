module GBA
  lib BIOS
    fun vBlankIntrWait = VBlankIntrWait()
    $if = BIOS_IF : UInt16
  end
end
