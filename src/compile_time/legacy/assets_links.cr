name = ARGV[0].downcase
STDOUT << <<-CR
module Assets
  lib #{name.camelcase}
    $map_start = _binary_build_#{name}_map_bin_start : UInt32
    $map_size = _binary_build_#{name}_map_bin_size : UInt32
    $set_start = _binary_build_#{name}_set_bin_start : UInt32
    $set_size = _binary_build_#{name}_set_bin_size : UInt32
    $pal_start = _binary_build_#{name}_pal_bin_start : UInt16
    $pal_size = _binary_build_#{name}_pal_bin_size : UInt32
  end
end
CR
