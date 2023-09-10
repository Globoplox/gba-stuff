struct Pointer(T)
  @[AlwaysInline]
  def []=(index, value)
    (self + index).value = value
  end

  #def [](index) : T*
  def [](index)
    #{ % if T < StaticArray %}
    #  (self + index).as({{T.type_vars.first}}*)
    #{ % else %}
      (self + index).value
    #{ % end %}
  end

  def null? : Bool
    address == 0
  end

  def self.null
    new 0u32
  end
end
