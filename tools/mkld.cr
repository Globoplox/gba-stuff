require "option_parser"
require "ecr"

input_files = [] of String
output_linker_script = nil
output_header = nil
  
OptionParser.parse do |parser|                                           
  parser.banner = "Usage: mk --script=script.ld --header=assets.h"
  
  parser.on("-l PATH", "--script=PATH", "The output linker script file. Created or overwriten.") do |path|
    output_linker_script = path
  end

  parser.on("-h PATH", "--header=PATH", "The output header file. Created or overwriten.") do |path|
    output_header = path
  end
  
  parser.unknown_args do |filenames, parameters|
    input_files = filenames
  end
  
end

raise "No output file specified" unless output_linker_script || output_header

names = input_files
File.open output_linker_script.not_nil!, "w", &.puts ECR.render "tools/assets.ld.ecr" if output_linker_script
File.open output_header.not_nil!, "w", &.puts ECR.render "tools/assets.h.ecr" if output_header
