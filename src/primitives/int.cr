struct Int
  def <<(other)
    unsafe_shl other
  end

  def >>(other)
    unsafe_shr other
  end
end
