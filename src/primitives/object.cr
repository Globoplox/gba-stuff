abstract class Object
  def ===(other)
    self == other
  end

  def try
    yield self
  end
end
