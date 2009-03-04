require 'rubygems'
require 'hoe'

task :default => ["make_gem"] 

EXT = "ext/blah.#{Hoe::DLEXT}"

Hoe.new('ruby-libsvm-swig', '0.2.0') do |p|
  p.author = 'Tom Zeng'
  p.email = 'tom.z.zeng@gmail.com'
  p.url = 'http://www.tomzconsulting.com'
  p.summary = 'Ruby wrapper of LIBSVM using SWIG'
  p.description = 'Ruby wrapper of LIBSVM using SWIG'
  
  p.spec_extras[:extensions] = "ext/extconf.rb"
  p.clean_globs << EXT << "ext/*.o" << "ext/Makefile"
end

task :make_gem => EXT

file EXT => ["ext/extconf.rb", "ext/svmc_wrap.cxx", "ext/svm.cpp", "ext/svm.h"] do
  Dir.chdir "ext" do
    ruby "extconf.rb"
    sh "make"
  end
end

task :copy_files do
  cp "libsvm-2.88/svm.h","ext/"
  cp "libsvm-2.88/svm.cpp","ext/"
  cp "libsvm-2.88/ruby/svmc_wrap.cxx","ext/"
  cp "libsvm-2.88/ruby/svm.rb","lib/"
end