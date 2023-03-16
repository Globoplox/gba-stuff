struct StaticArray(T, N)
  def []=(index, value : T)
    (pointerof(@buffer).as(T*) + index).value = value
  end

  def [](index) : T*
    pointerof(@buffer).as(T*) + index
  end
end

