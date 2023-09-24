require "option_parser"
require "yaml"

module U32IntConverter
  def self.from_yaml(ctx : YAML::ParseContext, node : YAML::Nodes::Node) : UInt32
    node.raise "Expected scalar, not #{node.kind}" unless node.is_a? YAML::Nodes::Scalar
    node.value.to_u32 prefix: true, underscore: true
  end
end

alias Spec = Hash(String, Asset)
abstract class Asset
  include YAML::Serializable

  abstract class WithPayload < Asset
    abstract def build(io)
  end

  property type : String
  property depends_on : Array(String)?

  abstract def generate(name, io)
end

require "./palette"
require "./tileset"

class Asset
  class Group < Asset
    def generate(name, io)
      io.puts <<-CR
        module Assets
          module #{name.camelcase}
            def self.load
              #{@depends_on.try &.map { |dep| "#{dep.camelcase}.load" }.join '\n' }     
            end
          end
        end
      CR
    end
  end

  use_yaml_discriminator "type", {
    palette: Palette,
    tileset: Tileset,
    group: Asset::Group
  }
end

module CLI
  extend self
  class_property spec_file : String?
  class_property output_file : String?
  class_property generated_file : String?
  
  PARSER = OptionParser.new do |parser|
    parser.banner = "Usage: COMMAND -f ASSETS_FILE OPERATION -o OUTPUT_FILE"
    
    parser.on "-f INPUT", "Set the input file" do |input|
      CLI.spec_file = input
    end
    
    parser.on "-g GENERATED", "Set the generated file" do |generated|
      CLI.generated_file = generated
    end
    
    parser.on "-o OUTPUT", "Set the output file" do |output|
      CLI.output_file = output
    end
    
    parser.on "-h", "--help", "Show this help" do
      puts parser
      exit
    end
  end

  def run
    PARSER.parse
    raise "Missing spec file" unless spec_path = spec_file
    raise "Missing output file" unless output_path = output_file
    raise "Missing generated file" unless generated_path = generated_file

    specs = File.open spec_path do |io|
      Spec.from_yaml io
    end

    objects = [] of String
    File.open generated_path, "w" do |generated|
      specs.each do |name, asset|
        if asset.is_a? Asset::WithPayload
          bin = "./build/asset_#{name}.bin"
          object = "./build/asset_#{name}.o"
          objects << object
          File.open bin, "w" do |output|
            asset.build output
          end
          `arm-none-eabi-objcopy -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.set.#{name} #{bin} #{object}`
        end
        asset.generate name, generated
      end
    end
        
    `arm-none-eabi-ld -no-warn-execstack -r #{objects.join ' '} -o #{output_path}`
    $?
  end
end

CLI.run
