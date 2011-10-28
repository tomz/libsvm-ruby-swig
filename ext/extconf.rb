require 'mkmf'
CONFIG["LDSHARED"] = "g++ -shared"
$CFLAGS = "#{ENV['CFLAGS']} -Wall -O3 "
if CONFIG["MAJOR"].to_i >= 1 && CONFIG["MINOR"].to_i >= 8
  $CFLAGS << " -DHAVE_DEFINE_ALLOC_FUNCTION"
end
create_makefile('libsvm-ruby-swig/libsvm')
=begin
extra_mk = <<-eos

eos

File.open("Makefile", "a") do |mf|
  mf.puts extra_mk
end
=end

