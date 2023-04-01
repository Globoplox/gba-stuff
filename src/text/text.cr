module Text

  # Take a string literal and transform it into a static array that can be copied as is into a tilemap.
  macro declare_string(str)
    StaticArray [ {{str.chars}} ]
  end
  
end
