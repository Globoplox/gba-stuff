require "option_parser"
require "yaml"
require "bmp"

# Fuck this makefile bull shit.
# This will output a single .o. Dependency management with makefile is juste stupidly too hard.

class BMP::Color
  def to_u32
    (0xffu32 << 24) | (@red.to_u32 << 16) | (@green.to_u32 << 8) | @blue
  end
end

module U32IntConverter
  def self.from_yaml(ctx : YAML::ParseContext, node : YAML::Nodes::Node) : UInt32
    node.raise "Expected scalar, not #{node.kind}" unless node.is_a? YAML::Nodes::Scalar
    node.value.to_u32 prefix: true, underscore: true
  end
end

module Assets
  extend self
  class Spec
    include YAML::Serializable
    class Palette
      include YAML::Serializable
      @[YAML::Field(converter: YAML::ArrayConverter(U32IntConverter))]
      property colors : Array(UInt32)
    end

    class Tileset
      include YAML::Serializable
      enum Format
        Bin
        Bmp
      end      

      property format : Format
      property translate : Hash(String, UInt32) = {} of String => UInt32
    end
        
    property palettes : Hash(String, Palette) =	{} of String => Palette
    property tilesets : Hash(String, Tileset) = {} of String => Tileset
  end

  def build(file, target)
    spec = File.open file do |io|
      Spec.from_yaml io
    end

    objects = [] of String

    spec.palettes.each do |name, palette|
      bin = "./build/palette_#{name}.bin"
      object = "./build/palette_#{name}.o"
      
      File.open bin, "w" do |io|
        palette.colors.each do |color|
          color.to_u16.to_io io, IO::ByteFormat::LittleEndian
        end
        0u16.to_io io, IO::ByteFormat::LittleEndian if spec.palettes[name].colors.size.odd?
      end

      `arm-none-eabi-objcopy -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.pal.#{name} #{bin} #{object}`
      objects << object 
    end
    
    spec.tilesets.each do |name, tileset|
      bin = "./build/tileset_#{name}.bin"
      object = "./build/tileset_#{name}.o"
      
      File.open bin, "w" do |output|
        case tileset.format
        when Spec::Tileset::Format::Bin
          File.open "assets/tilesets/#{name}.bin" do |input|
            IO.copy input, output
          end
        when Spec::Tileset::Format::Bmp
          bmp = BMP.from_file "assets/tilesets/#{name}.bmp"
          if bmp.width % 8 != 0 || bmp.height % 8 != 0
            puts "Asset dimensions are not tile aligned"
            exit 1
          end
          width = bmp.header.width // 8
          height = bmp.header.height // 8
          color_translate = tileset.translate.transform_keys { |color| color.to_u32(prefix: true, underscore: true).| 0xff000000 }
          (0...height).each do |tile_y|
            (0...width).each do |tile_x|
              (0...8).each do |y|
                (0...4).each do |x|
                  a = bmp.color tile_x * 8 + 2 * x, tile_y * 8 + y
                  color_1 = color_translate[(bmp.color tile_x * 8 + 2 * x, tile_y * 8 + y).to_u32] & 0xf
                  color_2 = color_translate[(bmp.color tile_x * 8 + 2 * x + 1, tile_y * 8 + y).to_u32] & 0xf
                  ((color_2 << 4) | color_1).to_u8.to_io output, IO::ByteFormat::LittleEndian
                end
              end
            end
          end
        end
      end

      `arm-none-eabi-objcopy -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.set.#{name} #{bin} #{object}`
      objects << object
    end

    `arm-none-eabi-ld -no-warn-execstack -r #{objects.join ' '} -o #{target}`
    $?
  end
end

input_file = nil
output_file = nil

parser = OptionParser.new do |parser|
  parser.banner = "Usage: COMMAND -f ASSETS_FILE OPERATION -o OUTPUT_FILE"

  parser.on "-f INPUT", "Set the input file" do |_input|
    input_file = _input
  end

  parser.on "-o OUTPUT", "Set the output file" do |_output|
    output_file = _output
  end
    
  parser.on "-h", "--help", "Show this help" do
    puts parser
    exit
  end
end

parser.parse

Assets.build input_file.not_nil!, output_file.not_nil!
