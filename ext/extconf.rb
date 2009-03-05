require 'mkmf'
CONFIG["CC"] = "g++"
$CFLAGS = "#{ENV['CFLAGS']} -Wall -O3 "
if CONFIG["MAJOR"].to_i >= 1 && CONFIG["MINOR"].to_i >= 8
  $CFLAGS << " -DHAVE_DEFINE_ALLOC_FUNCTION"
end
create_makefile('svmc')
