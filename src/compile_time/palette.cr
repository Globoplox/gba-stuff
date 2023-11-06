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
    if depends_on
      io.puts "Assets.declare_palette #{name.dump}, #{depends_on.try &.map(&.dump).join ','}"
    else
      io.puts "Assets.declare_palette #{name.dump}"
    end
  end
  
end

