struct Int
  def +(other)
    self &+ other
  end

  def *(other)
    self &* other
  end

  def <<(other)
    unsafe_shl other
  end

  def >>(other)
    unsafe_shr other
  end
  
  def ~
    self ^ -1
  end
end
