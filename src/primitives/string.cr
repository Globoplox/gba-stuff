class String

  def bytesize
    @bytesize
  end

  def to_unsafe
    pointerof(@c)
  end
end
