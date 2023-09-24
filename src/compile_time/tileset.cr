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

        module #{name.camelcase}
          @@loaded_at : UInt8?
          SIZE = pointerof(Symbols.#{name}_size).address.to_u32!
          DATA = pointerof(Symbols.#{name}_start)     
          
          def self.loaded_at
            @@loaded_at
          end

          def self.loaded_at=(value)
            @@loaded_at = value
          end

          def self.size
            SIZE
          end

          def self.data
            DATA
          end

          def self.load
            #{@depends_on.try &.map { |dep| "#{dep.camelcase}.load" }.join '\n' }                                                                                                     Loader.load_tileset #{name.camelcase}
          end
        end
      end
    CR
  end

end

