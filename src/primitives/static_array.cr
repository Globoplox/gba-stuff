struct StaticArray(T, N)
  # def []=(index, value : T)
  #   (pointerof(@buffer).as(T*) + index).value = value
  # end

  # def [](index) : T*
  #   pointerof(@buffer).as(T*) + index
  # end
  
  def []=(index, value : T)
    (pointerof(@buffer) + index).value = value
  end

  def [](index)
    (pointerof(@buffer) + index).value
  end
end

