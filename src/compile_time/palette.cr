class Palette < Asset::WithPayload
  include YAML::Serializable
  
  @[YAML::Field(converter: YAML::ArrayConverter(U32IntConverter))]
  property colors : Array(UInt32)
  
  def build(io)
    colors.each do |color|
      color.to_u16.to_io io, IO::ByteFormat::LittleEndian
	  end
  end
  
  def generate(name, io)
    io.puts <<-CR
      module Assets
        lib Symbols
          $#{name}_start = _binary___build_asset_#{name}_bin_start : UInt32
          $#{name}_size = _binary___build_asset_#{name}_bin_size : UInt32
        end

        #{name.camelcase} = Palette.new(before: #{deps_tuple}, size: pointerof(Symbols.#{name}_size).address.to_u32!, data: pointerof(Symbols.#{name}_start))        
      end
    CR
  end
  
end

