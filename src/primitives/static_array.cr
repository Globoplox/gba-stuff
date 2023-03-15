struct StaticArray(T, N)
  def []=(index, value : T)
    (pointerof(@buffer) + index).value = value
  end

  def [](index) : T
    (pointerof(@buffer) + index).value
  end
end
