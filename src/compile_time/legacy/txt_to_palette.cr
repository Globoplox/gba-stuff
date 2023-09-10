
unless ARGV[0]?
  puts "Missing input asset file name"
  exit 1
end

unless ARGV[1]?
  puts "Missing output target file name"
  exit 1
end

File.open ARGV[1], "w" do |output|
  i = 0
  File.open ARGV[0], "r" do |input|
    input.each_line do |line|
      next if line.empty?
      raise "Bad palette entry format: '#{line}'" unless line =~ /^(0x[0-9a-fA-F_]+|0b[01_]+)/
      $1.to_u16(prefix: true, underscore: true).to_io output, IO::ByteFormat::LittleEndian
      i += 1
    end
  end
  0u16.to_io output, IO::ByteFormat::LittleEndian if i.odd?  
end
