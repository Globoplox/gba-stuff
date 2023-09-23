module Indexable(T)
  abstract def [](index)
  abstract def size

  def each(& : T ->)
    i = 0
    while i < size
      yield self[i]
      i &+= 1
    end
  end

end
