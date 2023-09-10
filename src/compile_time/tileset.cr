class Tileset < Asset::WithPayload
  include YAML::Serializable
  
  property file : String
  property encoding : String = "bmp"
  
  def build(io)
    case @encoding
    when "raw"
      File.open @file do |input|
        IO.copy input, io
      end
    else raise "Unknown encoding for tileset with filename '#{@file}'"
    end
  end
  
  def generate(name, io)
    io.puts <<-CR
      module Assets
        lib Symbols
          $#{name}_start = _binary___build_asset_#{name}_bin_start : UInt32
          $#{name}_size = _binary___build_asset_#{name}_bin_size : UInt32
        end

        #{name.camelcase} = Tileset.new(before: #{deps_tuple}, size: pointerof(Symbols.#{name}_size).address.to_u32!, data: pointerof(Symbols.#{name}_start))        
      end
    CR
  end
  
end

