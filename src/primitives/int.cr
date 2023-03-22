struct Int
  @[AlwaysInline]
  def +(other)
    self &+ other
  end

  @[AlwaysInline]
  def *(other)
    self &* other
  end

  @[AlwaysInline]
  def <<(other)
    unsafe_shl other
  end

  @[AlwaysInline]
  def >>(other)
    unsafe_shr other
  end
end
