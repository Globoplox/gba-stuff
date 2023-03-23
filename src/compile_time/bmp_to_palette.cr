require "bmp" 

unless ARGV[0]?
  puts "Missing input asset file name"
  exit 1
end

unless ARGV[1]?
  puts "Missing output target file name"
  exit 1
end

bmp = BMP.from_file ARGV[0]

if bmp.width % 8 != 0 || bmp.height % 8 != 0
  puts "Asset dimensions are not tile aligned"
  exit 1
end

unless bmp.header.bit_per_pixel.in? [BMP::BitPerPixel::DEPTH_8, BMP::BitPerPixel::DEPTH_4, BMP::BitPerPixel::MONOCHROME]
  puts "Asset color depth is not supported."
  exit 1
end

# Lossyly convert from bmp 24/32bpp color to GBA 16bpp palette color. 
def bmp_to_gba(color : BMP::Color) : UInt16
  (color.red.to_u16 * 0b11111 // 0xFF) |
    ((color.green.to_u16 * 0b11111 // 0xFF) << 5) |
    ((color.blue.to_u16 * 0b11111 // 0xFF) << 10) |
    (color.reserved == 0 ? 0u16 : 1u16 << 15)
end

File.open ARGV[1], "w" do |io|
  bmp.color_table.each do |color|
    bmp_to_gba(color).to_io io, IO::ByteFormat::LittleEndian
  end
end
