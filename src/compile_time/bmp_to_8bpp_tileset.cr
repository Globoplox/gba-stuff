# In future, we can imagine a single tool that read all input assets,
# generate the tilesets, tilemaps, palette, optimaly.

# Fow now, we just read a single bmp picture, and output raw data ready for use in this form:
# `{tileset: StaticArray[], palette: StaticArray[]}`.
require "bmp" 

unless ARGV.first?
  puts "Missing input asset file name"
  exit 1
end

bmp = BMP.from_file ARGV.first

if bmp.width % 8 != 0 || bmp.height % 8 != 0
  puts "Asset dimensions are not tile aligned"
  exit 1
end

unless bmp.header.bit_per_pixel.in? [BMP::BitPerPixel::DEPTH_8, BMP::BitPerPixel::DEPTH_4, BMP::BitPerPixel::MONOCHROME]
  puts "Asset color depth is not palette based."
  exit 1
end

width = bmp.header.width // 8
height = bmp.header.height // 8

# Lossyly convert from bmp 24/32bpp color to GBA 16bpp palette color. 
def bmp_to_gba(color : BMP::Color) : UInt16
  (color.red.to_u16 * 0b11111 // 0xFF) |
    ((color.green.to_u16 * 0b11111 // 0xFF) << 5) |
    ((color.blue.to_u16 * 0b11111 // 0xFF) << 10) |
    (color.reserved == 0 ? 0u16 : 1u16 << 15)
end

STDOUT << "{"
STDOUT << "tileset: StaticArray["
(0...height).each do |tile_y|
  (0...width).each do |tile_x|
    (0...8).each do |y|
      (0...8).each do |x|
        bmp.data(tile_x * 8 + x, tile_y * 8 + y).first.to_s STDOUT
        STDOUT << "u8,"
      end
    end
  end
end
STDOUT << "],"
STDOUT << "palette: StaticArray["
bmp.color_table.each do |color|
  bmp_to_gba(color).to_s STDOUT
  STDOUT << "u16,"
end
STDOUT << "],"
STDOUT << "}"
STDOUT.flush
