# Parse a BMP picture file.
# Tested for 8 bpp only.
# Unlikely that it works with other bit per pixel values.
class BMP

  SIGNATURE = 0x4D42

  enum HeaderType
    BITMAPCOREHEADER = 12
    BITMAPINFOHEADER = 40
  end
  
  enum Compression
    BI_RGB = 0
    BI_BITFIELDS = 3
    BI_RLE8 = 1
    BI_RLE4 = 2
    BI_JPEG = 4
    BI_PNG = 5
    BI_ALPHABITFIELDS = 6
    BI_CMYK = 0xB
    BI_CMYKRLE8 = 0xC
    BI_CMYKRLE4 = 0xD
  end

  UNSUPPORTED_COMPRESSION = [
    Compression::BI_BITFIELDS, Compression::BI_ALPHABITFIELDS,
    Compression::BI_RLE4, Compression::BI_RLE8,
    Compression::BI_JPEG, Compression::BI_PNG,
    Compression::BI_CMYK, Compression::BI_CMYKRLE8, Compression::BI_CMYKRLE4]

  enum BitPerPixel
    MONOCHROME = 1
    DEPTH_4 = 4
    DEPTH_8 = 8
    DEPTH_16 = 16
    DEPTH_24 = 24
  end

  class InfoHeader
    property width : UInt32
    property height : UInt32
    property planes : UInt16
    property bit_per_pixel : BitPerPixel
    property compression : Compression
    property image_size : UInt32
    property x_pixel_per_m : UInt32
    property y_pixel_per_m : UInt32
    property colors_used : UInt32
    property important_colors : UInt32
    property red_bitmask : UInt32?
    property green_bitmask : UInt32?
    property blue_bitmask : UInt32?
    property alpha_bitmask : UInt32?

    def initialize(io : IO)
      @width = io.read_bytes typeof(@width), IO::ByteFormat::LittleEndian
      @height = io.read_bytes typeof(@height), IO::ByteFormat::LittleEndian
      @planes = io.read_bytes typeof(@planes), IO::ByteFormat::LittleEndian
      @bit_per_pixel = BitPerPixel.from_value io.read_bytes Int16, IO::ByteFormat::LittleEndian
      @compression = Compression.from_value io.read_bytes Int32, IO::ByteFormat::LittleEndian
      raise "Compression mode #{@compression} is not supported" if @compression.in? UNSUPPORTED_COMPRESSION
      @image_size = io.read_bytes typeof(@image_size), IO::ByteFormat::LittleEndian
      @x_pixel_per_m = io.read_bytes typeof(@x_pixel_per_m), IO::ByteFormat::LittleEndian
      @y_pixel_per_m = io.read_bytes typeof(@y_pixel_per_m), IO::ByteFormat::LittleEndian
      @colors_used = io.read_bytes typeof(@colors_used), IO::ByteFormat::LittleEndian
      @important_colors = io.read_bytes typeof(@important_colors), IO::ByteFormat::LittleEndian

      if @colors_used == 0
        case @bit_per_pixel
        when BitPerPixel::MONOCHROME then @colors_used = 2 
        when BitPerPixel::DEPTH_4 then @colors_used = 16 
        when BitPerPixel::DEPTH_8 then @colors_used = 256
        end
      else
        case @bit_per_pixel
        in BitPerPixel::MONOCHROME then raise "Bad palette size #{@colors_used} for monochrome bmp, expected 2" unless @colors_used == 2
        in BitPerPixel::DEPTH_4 then raise "Bad palette size #{@colors_used} for 4bpp bmp, expected up to 16" unless @colors_used <= 16
        in BitPerPixel::DEPTH_8 then raise "Bad palette size #{@colors_used} for 8bpp bmp, expected up to 256" unless @colors_used <= 256
        in BitPerPixel::DEPTH_16
          case @compression
          when Compression::BI_RGB then raise "Bad palette size #{@colors_used} for 16bpp bmp with RGB compression, expected 0" unless @colors_used == 0
          else raise "Unsupported compression #{@compression}"
          end
        in BitPerPixel::DEPTH_24 then raise "Bad palette size #{@colors_used} for 24bpp bmp, expected 0" unless @colors_used == 0
        end
      end
      
      if @compression == Compression::BI_BITFIELDS
        @red_bitmask = io.read_bytes UInt32, IO::ByteFormat::LittleEndian                                                                
        @green_bitmask = io.read_bytes UInt32, IO::ByteFormat::LittleEndian                                                                
        @blue_bitmask = io.read_bytes UInt32, IO::ByteFormat::LittleEndian                                                                
      end
      @alpha_bitmask = io.read_bytes UInt32, IO::ByteFormat::LittleEndian if @compression == Compression::BI_ALPHABITFIELDS
    end
  end

  class Color
    property red : UInt8
    property green : UInt8
    property blue : UInt8
    property reserved : UInt8

    def initialize(io : IO)
      @blue = io.read_bytes typeof(@blue), IO::ByteFormat::LittleEndian
      @green = io.read_bytes typeof(@green), IO::ByteFormat::LittleEndian
      @red = io.read_bytes typeof(@red), IO::ByteFormat::LittleEndian
      @reserved = io.read_bytes typeof(@reserved), IO::ByteFormat::LittleEndian
    end

    def initialize(@red, @green, @blue, @reserved = 0u8) end

    def initialize(data : UInt32)
      @reserved = ((data & 0xff000000) >> 24).to_u8
      @blue = ((data & 0xff0000) >> 16).to_u8
      @green = ((data & 0xff00) >> 8).to_u8
      @red = (data & 0xff).to_u8
    end
  end

  property signature : UInt16
  property file_size : UInt32
  property reserved : UInt32
  property data_offset : UInt32

  property header_type : HeaderType
  property header : InfoHeader

  property color_table : Array(Color)
  property pixel_data : Bytes

  def width
    @header.width
  end

  def height
    @header.height
  end
  
  def initialize(io : IO)
    @signature = io.read_bytes typeof(@signature), IO::ByteFormat::LittleEndian

    raise "bad signature: 0x#{@signature.to_s(16)}" unless @signature == SIGNATURE
    
    @file_size = io.read_bytes typeof(@file_size), IO::ByteFormat::LittleEndian
    @reserved = io.read_bytes typeof(@reserved), IO::ByteFormat::LittleEndian
    @data_offset = io.read_bytes typeof(@data_offset), IO::ByteFormat::LittleEndian
    @header_type = HeaderType.from_value io.read_bytes Int32, IO::ByteFormat::LittleEndian
    raise "Header type #{@header_type} is not supported" if @header_type != HeaderType::BITMAPINFOHEADER
    @header = InfoHeader.new io

    @color_table = Array(Color).new @header.colors_used do
      Color.new io
    end
    
    scan_line_padding_bits = width * @header.bit_per_pixel.value % 32
    scan_line_padding_bits = 32 - scan_line_padding_bits if scan_line_padding_bits != 0
    scan_line_size_byte = (width * @header.bit_per_pixel.value + scan_line_padding_bits) // 8
    #STDOUT.puts "w:#{@width}, h:#{@height}, bpp:#{@bit_per_pixel}, scan:#{scan_line_size_byte}"
    @pixel_data = Bytes.new(scan_line_size_byte * height)
    read_bytes = io.read(@pixel_data)
    raise "Pixel data ended unexpectedly after reading #{read_bytes} bytes on exptected #{@pixel_data.size} bytes" if read_bytes != @pixel_data.size
  end

  def pixel_data_offset(x, y)
    scan_line_padding_bits = width * @header.bit_per_pixel.value % 32
    scan_line_padding_bits = 32 - scan_line_padding_bits if scan_line_padding_bits != 0
    scan_line_size_byte = (width * @header.bit_per_pixel.value + scan_line_padding_bits) // 8
    y = height - y - 1
    (scan_line_size_byte * y) + (@header.bit_per_pixel.value * x // 8)
  end

  def pixel_data(x, y)
    offset = pixel_data_offset x, y
    case @header.bit_per_pixel
    in BitPerPixel::MONOCHROME then (@pixel_data[offset] >> (7 - width % 8)) & 1
    in BitPerPixel::DEPTH_4 then (@pixel_data[offset] >> (width.even? ? 4 : 0)) & 0xf
    in BitPerPixel::DEPTH_8 then @pixel_data[offset]
    in BitPerPixel::DEPTH_16 then IO::ByteFormat::LittleEndian.decode UInt16, @pixel_data + offset
    in BitPerPixel::DEPTH_24 then IO::ByteFormat::LittleEndian.decode UInt32, @pixel_data + offset 
    end
  end

  def pixel_color(x, y) : Color
    data = pixel_data x, y
    case @header.bit_per_pixel
    in BitPerPixel::MONOCHROME then @color_table[data]
    in BitPerPixel::DEPTH_4 then @color_table[data]
    in BitPerPixel::DEPTH_8 then @color_table[data]
    in BitPerPixel::DEPTH_16
      case @header.compression
      when Compression::BI_RGB
        Color.new(
          blue: (data & 0b11111).to_u8,
          green: ((data & 0b1111100000) >> 5).to_u8,
          red: ((data & 0b111110000000000) >> 10).to_u8,
        )
      else raise "Unuspoorted compression #{@header.compression}"
      end
    in BitPerPixel::DEPTH_24 then Color.new(data.to_u32)
    end
  end


  def self.from_file(path)
    File.open path, "r" do |io|
      self.new io
    end
  end
end
