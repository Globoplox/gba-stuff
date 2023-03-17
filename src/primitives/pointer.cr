struct Pointer(T)
#   def []=(index, value)
#     {% if T < StaticArray %}
#       (self.as({{T.type_vars.first}}*) + index).value = value
#     {% else %}
#       (self + index).value = value
#     {% end %}
#   end

  # def [](index) : T*
  #   {% if T < StaticArray %}
  #     (self + index).as({{T.type_vars.first}}*)
  #   {% else %}
  #     (self + index).value
  #   {% end %}
  # end
end
