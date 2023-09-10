require "bmp" 

unless ARGV[0]?
  puts "Missing input asset file name"
  exit 1
end

unless ARGV[1]?
  puts "Missing tilemap output target file name"
  exit 1
end
unless ARGV[2]?
  puts "Missing tileset output target file name"
  exit 1
end
unless ARGV[3]?
  puts "Missing palette output target file name"
  exit 1
end

bmp = BMP.from_file ARGV[0]

# TODO: Actually asset should be 8*8*32 because tilemap are fixed size.
if bmp.width % 8 != 0 || bmp.height % 8 != 0
  puts "Asset dimensions are not tile aligned"
  exit 1
end

unless bmp.header.bit_per_pixel.in? [BMP::BitPerPixel::DEPTH_8, BMP::BitPerPixel::DEPTH_4, BMP::BitPerPixel::MONOCHROME]
  puts "Asset color depth is not supported."
  exit 1
end

width = bmp.header.width // 8
height = bmp.header.height // 8

class Tile < Array(Bytes)
  H_FLIPPED = (0...(8*8)).to_a.in_groups_of(8).map(&.map(&.not_nil!).reverse).flatten
  V_FLIPPED = (0...(8*8)).to_a.in_groups_of(8).map(&.map(&.not_nil!)).reverse.flatten
  HV_FLIPPED =  (0...(8*8)).to_a.in_groups_of(8).map(&.map(&.not_nil!).reverse).reverse.flatten

  def values_at(array : Array(Int32)) : Array(Bytes)
    array.map do |i|
      self[i]
    end
  end
  
  def h_flipped
    values_at H_FLIPPED
  end

  def v_flipped
    values_at V_FLIPPED
  end

  def hv_flipped
    values_at HV_FLIPPED
  end
end

tiles = [] of Tile
map = Array(UInt16).new initial_capacity: width * height

TILEMAP_HORIZONTAL_FLIP = 1u16 << 0xA
TILEMAP_VERTICAL_FLIP = 1u16 << 0xB

(0...height).each do |tile_y|
  (0...width).each do |tile_x|
    tile = Tile.new initial_capacity: 8 * 8
    (0...8).each do |y|
      (0...8).each do |x|
        tile << bmp.data tile_x * 8 + x, tile_y * 8 + y
      end
    end
    if index = tiles.index tile
      map << index.to_u16
    elsif index = tiles.index tile.h_flipped
      map << (index.to_u16 | TILEMAP_HORIZONTAL_FLIP)
    elsif index = tiles.index tile.v_flipped
      map << (index.to_u16 | TILEMAP_VERTICAL_FLIP)
    elsif index = tiles.index tile.hv_flipped
      map << (index.to_u16 | TILEMAP_HORIZONTAL_FLIP | TILEMAP_VERTICAL_FLIP)
    else
      map << tiles.size.to_u16
      tiles << tile
    end
  end
end


File.open ARGV[1], "w" do |io|
  map.each do |entry|
    entry.to_io io, IO::ByteFormat::LittleEndian
  end
end unless ARGV[1] == "_"

File.open ARGV[2], "w" do |io|
  tiles.each do |tile|
    tile.each do |pixel_data|
      pixel_data.first.to_io io, IO::ByteFormat::LittleEndian
    end
  end
end unless ARGV[2] == "_"

def bmp_to_gba(color : BMP::Color) : UInt16
  (color.red.to_u16 * 0b11111 // 0xFF) |
    ((color.green.to_u16 * 0b11111 // 0xFF) << 5) |
    ((color.blue.to_u16 * 0b11111 // 0xFF) << 10) |
    (color.reserved == 0 ? 0u16 : 1u16 << 15)
end

File.open ARGV[3], "w" do |io|
  bmp.color_table.each do |color|
    bmp_to_gba(color).to_io io, IO::ByteFormat::LittleEndian
  end
end unless ARGV[3] == "_"

