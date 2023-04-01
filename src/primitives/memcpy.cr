# Copy blocks of FOUR BYTES.
# fun memcpy(from : UInt32*, to : UInt32*, size : UInt32)
#   i = 0
#   size = size >> 2
#   while i < size
#     to[i] = from[i]
#     i &+= 1
#   end
# end
