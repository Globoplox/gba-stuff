require "./indexable"

struct StaticArray(T, N)
include Indexable(T)
  
  macro [](*args)
    %array = uninitialized StaticArray(typeof({{*args}}), {{args.size}})
    {% for arg, i in args %}
      %array[{{i}}] = {{arg}}
    {% end %}
    %array
  end

  def size
    N
  end
    
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


#class Array(T)
#  def initialize()
#end
