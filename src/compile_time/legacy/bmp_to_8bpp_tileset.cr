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

width = bmp.header.width // 8
height = bmp.header.height // 8

File.open ARGV[1], "w" do |io|
  (0...height).each do |tile_y|
    (0...width).each do |tile_x|
      (0...8).each do |y|
        (0...8).each do |x|
          bmp.data(tile_x * 8 + x, tile_y * 8 + y).first.to_io io, IO::ByteFormat::LittleEndian
        end
      end
    end
  end
end
