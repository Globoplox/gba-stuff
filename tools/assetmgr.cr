require "option_parser"
require "./bmp"

# BMP BBP mode that have a palette.
# Other modes would require a way to quantize picture to build a color palette.
SUPPORTED_BPP = [BMP::BitPerPixel::DEPTH_8, BMP::BitPerPixel::DEPTH_4, BMP::BitPerPixel::MONOCHROME]

# Lossyly convert from bmp 32bpp color to GBA 16bpp palette color. 
def bmp_to_gba(color : BMP::Color): UInt16
  (color.red.to_u16 * 0b11111 // 0xFF) |
    ((color.green.to_u16 * 0b11111 // 0xFF) << 5) |
    ((color.blue.to_u16 * 0b11111 // 0xFF) << 10) |
    (color.reserved == 0 ? 0u16 : 1u16 << 15)
end

# Dump the raw palette data into the given file. Return the palette size.
def make_palette(bmp, output_path)
  File.open output_path, "w" do |file|
    bmp.color_table.each do |color|
      bmp_to_gba(color).to_io file, IO::ByteFormat::LittleEndian
    end
  end
  bmp.color_table.size
end

# Dump the raw pixels data into the given file.
def make_tileset_8bpp(bmp, palette_offset, output_path)
  File.open output_path, "w" do |file|
    width = bmp.header.width // 8
    height = bmp.header.height // 8
    (0...height).each do |tile_y|
      (0...width).each do |tile_x|
        (0...8).each do |y|
          (0...8).each do |x|
            (bmp.pixel_data(tile_x * 8 + x, tile_y * 8 + y) + palette_offset).to_io file, IO::ByteFormat::LittleEndian
          end
        end
      end
    end
  end
end

def main
  bpp = :bpp8
  input_file = nil
  output_file = nil
  output_directory = nil
  command = nil
  palette_offset = nil
  palette_offset_file = nil
  
  OptionParser.parse do |parser|                                           
    parser.banner = "Usage: blah command options input_file"
    
    parser.on("palette", "Output the raw palette of the given bitmap.") do
      abort "Only one command can be specified. Previously set command: #{command}." unless command.nil?
      command = :palette
    end
    
    parser.on("tileset", "Output the raw pixel data of the given bitmap.") do
      abort "Only one command can be specified. Previously set command: #{command}." unless command.nil?
      command = :tileset
    end
    
    parser.on("auto", "Output both palette and pixel data in separate files.") do
      abort "Only one command can be specified. Previously set command: #{command}." unless command.nil?
      command = :auto
    end
    
    parser.on("-o PATH", "--output=PATH", "The output file. Created or overwriten.") do |path|
      output_file = path
    end
    
    parser.on("-d DIR", "--directory=DIR", "The output directory to use if no output file is given or in auto mode.") do |path|
      output_dir = path
    end
    
    parser.on("--4bpp", "Set the mode to 4 bit per pixel tile. Default to 8bpp mode.") do |path|
      bpp = :bpp4
    end
    
    parser.on("--8bpp", "Set the mode to 8 bit per pixel tile. This is the default.") do |path|
      bpp = :bpp8
    end
    
    parser.on("--palette-offset=OFFSET", "Set an offset to apply to tiles values") do |offset|
      palette_offset = offset.to_u16
    end
    
    parser.on("--palette-offset-file=PATH", "File to read and write the palette offset.") do |path|
      palette_offset_file = path
    end

    parser.unknown_args do |filenames, parameters|
      input_file = filenames.first
    end
  
  end
  
  raise "No command specified." unless command
  raise "Cannot specify an output file in mode 'auto'." if command == :auto && output_file
  raise "Palette offset and palette offset file are incompatible." if palette_offset && palette_offset_file
  raise "Input file is missing from command line." unless input_file
  
  bmp = BMP.from_file Path.new input_file.not_nil!

  unless (bmp.header.width % 8) == 0 && (bmp.header.width % 8) == 0
    raise "Input pictures dimensions should be multiples of 8 pixels, found: #{bmp.header.width}x#{bmp.header.height}"
  end
  
  raise "Unsupported color depth: #{bmp.header.bit_per_pixel}. Supported depth: #{SUPPORTED_BPP}." unless bmp.header.bit_per_pixel.in? SUPPORTED_BPP
  
  palette_offset = File.read(palette_offset_file.not_nil!).to_u16 if palette_offset_file
  palette_offset ||= 0u16
  raise "Warning: palette offset overflow maximum value 256." if palette_offset.not_nil! >= 256
  
  raise "Bpp mode 4bpp is not yet supported." if bpp == :bpp4

  Dir.mkdir_p output_directory.not_nil! if output_directory
  output_directory ||= "."

  base_name = File.basename(input_file.not_nil!).rstrip(File.extname(input_file.not_nil!))

  if command == :tileset
    output_file ||= Path [output_directory, "#{base_name}.tileset.bin"]
    make_tileset_8bpp bmp, palette_offset.not_nil!, output_file.not_nil!
  end

  if command == :palette
    output_file ||= Path [output_directory, "#{base_name}.palette.bin"]
    palette_offset = palette_offset.not_nil! + make_palette bmp, output_file.not_nil!
  end

  if command == :auto
    output_file = Path [output_directory, "#{base_name}.tileset.bin"]
    make_tileset_8bpp bmp, palette_offset.not_nil!, output_file.not_nil!
    output_file = Path [output_directory, "#{base_name}.palette.bin"]
    palette_offset = palette_offset.not_nil! + make_palette bmp, output_file.not_nil!
  end
end

main
